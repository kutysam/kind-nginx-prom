# Introduction

This project simply creates a kind cluster(with 1 control and 1 worker), ingress-nginx, prometheus, 2 test k8s apps with ingresses, health-checks, load testing and eventually exportation of nginx metrics to csv format.

## Pre-requisites

Do note that all commands specified must be ran at the root of this directory.

1. OS must be UBUNTU. Ideal Version is 18.
   1. If you want to use other distros:
      1. You have to install the pre-req items in your own way
      1. Modification of pre-req scripts is a must due to the apt repo key addition.
1. Architecture must be amd64.
1. Ideal approach would be for the prerequisites to be packaged into a image like AMI image so that we don't have to install it always.

### [PRE-REQ] The following commands require sudo access as we will be moving the files to `/usr/local/bin` directory

1. [Docker](https://docs.docker.com/engine/install/ubuntu/)
   1. Required to create KinD clusters.
   1. If you do not have it, run `scripts/install-docker.sh`
   1. Script will download the latest version. (Tested version: v20)

1. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
   1. Required to run kubectl commands
   1. If you do not have it, run `scripts/install-kubectl.sh`
   1. Script will download the latest version. (Tested version: v1.22)

1. [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-with-a-package-manager)
   1. Required to create Kind cluster
   1. If you do not have it, run `scripts/install-kind.sh`
   1. Script will download the latest version. (Tested version: v0.11.1)

1. [Helm](https://helm.sh/docs/intro/install/)
   1. Required to install packages for various k8s applications
   1. If you do not have it, run `scripts/install-helm.sh`
   1. Script will download the latest version. (Tested version: v3.7)

1. [k6](https://k6.io/docs/getting-started/installation/)
   1. Installs k6 load test on your system for load testing.
   1. If you do not have it, run `scripts/install-k6.sh`
   1. Script will download the latest version. (Tested version: v0.35)

1. [python3](https://www.python.org/downloads/)
   1. Installs python3. This is required for converting json to csv from load testing.
   1. Ubuntu should have it installed already.

If there are version issues, feel free to modify the script to suit the tested version.

If you would like to run an all-in-one-script, execute `./pre-reg-run-all.sh`.
Once again, this is only tested on ubuntu 18.04 for now.

## Steps to run automated script

Do note that all commands specified must be ran at the root of this directory.

1. Execute the script `./automated-run-all.sh`

1. It will execute the scripts from 1 - 7 in order.
   1. `1-install-multi-kind-cluster.sh`
      1. Installs a multi node KinD cluster on your machine. Uses the configfile located at `config/multi-node-kind.yaml`

   1. `2-install-ingress-nginx.sh`
      1. Installs the nginx ingress controller (modified for KinD)

   1. `3-install-foo-bar.sh`
      1. Installs foo bar ingress, service, pod via kubectl

   1. `4-install-prometheus.sh`
      1. Installs prometheus via helm

   1. `5-health-check.sh`
      1. Checks if the endpoints are alive.

   1. `6-load-test.sh`
      1. Runs k6 load test on the ingress (Takes 240seconds, 120seconds per service)

   1. `7-metrics.sh` and `7-metrics.py`
      1. kube port forwards the prometheus endpoint for PQL query
      1. Runs metric collection and output to CSV file (For the last 10 minutes)

1. Retrieve your csv file at `results/results.csv`
   1. Format of the csv is as follows `starttime,endtime,avg_req,avg_memory,avg_cpu`. Interval is set to 1 second as per requirements.

Both pre-req and automated run has been tested on a GCP E2 machine with ubuntu 18.04 image and all works well!

## Important information

1. You should only run `./automated-run-all.sh` at **root directory**.

1. The paths are relative and works only with running at root path right now. If you run the individual scripts in scripts folder, be sure to run it from the root, such as, `bash scripts/6-load-test.sh`.

1. Additionally, if your CSV file has `-1` entries, it means the result is not readily available from prometheus for that given period.

1. If you do get a permission issue on docker access when you run automated script, please exit the terminal and re-enter. This is because the group hasn't refreshed. `newgrp docker` is another option.

## Other information

For `5-health-check.sh`, I am unsure on what does it mean by checking via kubernetes api? Ingress itself does not have a health check.
We can technically parse the events api to see if there are errors but I'm unsure on what is exactly expected.
Since we can do a curl to the ingress, that should be suffient.

For prometheus, we can either let it automatically scrape (which is what i did), or we can configure the configmap to let define the endpoint manually which is not ideal.

The script will have some sleep commands as this is an automated script. The main reason is, prometheus needs some time to scrape the data and we are spinning up everything and expecting results too fast. There is a 100 second sleep after load testing to ensure that there will be data in prometheus database.

## Future work

1. Set specific versions for the pre-requisites.

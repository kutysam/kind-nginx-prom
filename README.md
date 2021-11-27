# Introduction


## Pre-requisites

Do note that all commands specified must be ran at the root of this directory.

1. OS should be linux Ubuntu Version 18
   1. If you want to use other distros, you have to install docker / kubectl in your own way)

1. Architecture must be amd64.

### The following commands require sudo access as we will be moving the files to `/usr/local/bin` directory

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

## What does this do?

1. Create a multi node kind cluster, control-plane and worker-node.

1. Installs [kubernetes nginx ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/) onto your cluster via helm.

## Steps to run automated script

Do note that all commands specified must be ran at the root of this directory.

1. Execute the script `./automated-run-all.sh`

1. It will execute the scripts from 1 - 6 in order.
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
      1. Runs k6 load test on the ingress (Takes 240seconds)

   1. `7-metrics.sh` and `7-metrics.py`
      1. kube port forwards the prometheus endpoint for pql query
      1. Runs metric collection and output to CSV file (For the last 10 minutes)

1. Retrieve your csv file at `results/results.csv`

## Important information

You should only run automated-run-all.sh at root directory. The paths are relative and works only with running at root path right now. If you run the individual scripts in scripts folder, be sure to run it from the root, such as, `bash scripts/6-load-test.sh`.

## Other information

For 5-health-check.sh, I am unsure on what does it mean by checking via kubernetes api? Ingress itself does not have a health check.
We can technically parse the events api to see if there are errors but I'm unsure on what is exactly expected.
Since we can do a curl to the ingress, that should be suffient.

For prometheus, we can either let it automatically scrape (which is what i did), or we can configure the configmap to let define the endpoint manually.

## Future work

1. Set specific versions for the pre-requisites.

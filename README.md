# Introduction

This project simply creates a kind cluster, ingress-nginx, prometheus, 2 test k8s apps with ingresses, health-checks, load testing and eventually exportation of nginx metrics to csv format.

## Pre-requisites

Do note that all commands specified must be ran at the root of this directory.

1. OS must be UBUNTU. Ideal Version is 18.
   1. If you want to use other distros
      1. You have to install docker / kubectl in your own way)
      1. Modification of pre-req scripts is a must due to the apt repo key addition.
1. Architecture must be amd64.
1. Ideal approach would be for the prerequisites to be packaged into a image like AMI image.

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

## Future work

1. Set specific versions for the pre-requisites.

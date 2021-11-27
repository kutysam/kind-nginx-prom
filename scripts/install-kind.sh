#!/bin/bash

### Download kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
sudo install -o root -g root -m 0755 kind /usr/local/bin/kind
rm -rf kind

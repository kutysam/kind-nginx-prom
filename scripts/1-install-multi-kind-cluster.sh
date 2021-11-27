#!/bin/bash

### Run a multi-node kind cluster
echo "--- Creating KinD Cluster ---"
kind create cluster --config config/multi-node-kind.yaml
echo "--- KinD Cluster Created ---"

#!/bin/bash

### Run a multi-node kind cluster
echo "--- 1. Creating KinD Cluster ---"
kind create cluster --config config/multi-node-kind.yaml

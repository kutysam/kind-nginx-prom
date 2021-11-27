#!/bin/bash

### Run a multi-node kind cluster
echo "\n--- Creating Kind Cluster ---\n"
kind create cluster --config config/multi-node-kind.yaml
echo "\n--- Kind Cluster Created ---\n"

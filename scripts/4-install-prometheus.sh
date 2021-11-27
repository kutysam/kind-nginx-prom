#!/bin/bash

echo "--- 4. Installing Prometheus ---"

kubectl create namespace monitoring

### Install prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install -n=monitoring prometheus prometheus-community/prometheus

kubectl wait --namespace monitoring \
  --for=condition=ready pod \
  --selector=component=server \
  --timeout=300s

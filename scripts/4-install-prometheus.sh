#!/bin/bash
kubectl create namespace monitoring

### Install prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install -n=monitoring prometheus prometheus-community/prometheus

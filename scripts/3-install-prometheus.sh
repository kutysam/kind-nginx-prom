#!/bin/bash

### Install prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install -n=monitoring prometheus prometheus-community/prometheus

#!/bin/bash

kubectl port-forward svc/prometheus-server 8081:80 &

python3 6-metrics.py

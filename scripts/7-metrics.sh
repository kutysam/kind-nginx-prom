#!/bin/bash

kubectl port-forward -n=monitoring svc/prometheus-server 8081:80 &

python3 7-metrics.py

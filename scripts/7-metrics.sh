#!/bin/bash
echo "--- 7. Getting Metrics to CSV ---"
kubectl port-forward -n=monitoring svc/prometheus-server 8081:80 &

python3 scripts/7-metrics.py

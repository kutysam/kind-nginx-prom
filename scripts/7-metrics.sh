#!/bin/bash
echo "--- 7. Getting Metrics to CSV ---"
kubectl port-forward -n=monitoring svc/prometheus-server 8081:80 &

echo "Will be sleeping for 100 seconds for latest metrics to be populated to prometheus. Please be patient."
sleep 100

python3 scripts/7-metrics.py

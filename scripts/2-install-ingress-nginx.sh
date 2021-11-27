#!/bin/bash

### Install nginx ingress (for kind clusters)
echo "--- 2. Installing ingress-nginx ---"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
echo "--- ingress-nginx Installed ---"

echo "--- modify deployment for wildcard ingress ---"
# We need to modify the deployment due to wildcards https://kubernetes.github.io/ingress-nginx/user-guide/monitoring/#wildcard-ingresses
kubectl patch deployment ingress-nginx-controller -n ingress-nginx --type "json" -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--metrics-per-host=false"}]'

echo "--- modifying nginx service to let prometheus scrape ---"
kubectl patch svc ingress-nginx-controller -n ingress-nginx --type "json" -p '[{"op":"add","path":"/spec/ports/-","value": {"name":"prometheus","port": 10254,"targetPort":10254}}]'
kubectl patch svc ingress-nginx-controller -n ingress-nginx --type "json" -p '[{"op":"add","path":"/metadata/annotations","value": {"prometheus.io/port":"10254",prometheus.io/scrape: "true"}}]'

sleep 10 # Need a sleep for k8s to trigger a restart due to patch ^
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s

sleep 20 # Let nginx stabalize

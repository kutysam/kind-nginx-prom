#!/bin/bash

### Install nginx ingress (for kind clusters)
echo "--- Installing ingress-nginx ---"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
echo "--- ingress-nginx Installed ---"

echo "--- modify deployment for wildcard ingress ---"
# We need to modify the deployment due to wildcards https://kubernetes.github.io/ingress-nginx/user-guide/monitoring/#wildcard-ingresses
kubectl patch deployment ingress-nginx-controller -n ingress-nginx --type "json" -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--metrics-per-host=false"}]'

echo "--- modifying nginx service to let prometheus scrape ---"
kubectl patch svc ingress-nginx-controller -n ingress-nginx --type "json" -p '[{"op":"add","path":"/spec/ports/-","value": {"name":"prometheus","port": 10254,"targetPort":10254}}]'
kubectl patch svc ingress-nginx-controller -n ingress-nginx --type "json" -p '[{"op":"add","path":"/metadata/annotations","value": {"prometheus.io/port":"10254",prometheus.io/scrape: "true"}}]'

#!/bin/bash

### Install nginx ingress (for kind clusters)
echo "--- Installing ingress-nginx ---"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
echo "--- ingress-nginx Installed ---"

#!/bin/bash

kubectl apply -f config/foobartemplate.yaml

kubectl wait --namespace default \
  --for=condition=ready pod \
  --selector=app=foo \
  --timeout=300s

kubectl wait --namespace default \
  --for=condition=ready pod \
  --selector=app=bar \
  --timeout=300s

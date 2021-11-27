#!/bin/bash

scripts/1-install-multi-kind-cluster.sh && \
scripts/2-install-ingress-nginx && \
scripts/3-install-prometheus.sh && \
scripts/4-health-check.sh && \
scripts/5-load-test.sh && \
scripts/6-metrics.sh

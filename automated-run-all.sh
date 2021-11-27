#!/bin/bash

scripts/1-install-multi-kind-cluster.sh && \
scripts/2-install-ingress-nginx.sh && \
scripts/3-install-foo-bar.sh && \
scripts/4-install-prometheus.sh && \
scripts/5-health-check.sh && \
scripts/6-load-test.sh && \
scripts/7-metrics.sh

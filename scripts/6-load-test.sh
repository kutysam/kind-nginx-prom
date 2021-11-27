#!/bin/bash

echo "--- 6. LOAD TESTING ---"

k6 run --vus 50 --duration 120s config/loadtestbar.js
k6 run --vus 50 --duration 120s config/loadtestfoo.js

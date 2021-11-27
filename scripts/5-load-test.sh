#!/bin/bash

### Install k6 load test
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 379CE192D401AB61
echo "deb https://dl.bintray.com/loadimpact/deb stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get install k6

k6 run --vus 50 --duration 120s ../config/loadtestbar.js
k6 run --vus 50 --duration 120s ../config/loadtestfoo.js

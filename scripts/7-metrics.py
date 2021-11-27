import time
import csv
import requests
from collections import defaultdict
DURATION = 600  # 600 seconds
INTERVAL = 1  # 1 second

memory_metric = 'avg(nginx_ingress_controller_nginx_process_resident_memory_bytes{controller_pod=~".*",controller_class=~".*",controller_namespace=~".*"})'
cpu_metric = 'avg(rate(nginx_ingress_controller_nginx_process_cpu_seconds_total{controller_pod=~".*",controller_class=~".*",controller_namespace=~".*"}[5m]))'
avg_req_metric = 'avg(irate(nginx_ingress_controller_requests{controller_pod=~".*",controller_class=~".*",controller_namespace=~".*",ingress=~".*"}[5m]))'

# There will always be only 1 array as we are summing all ingress / service etc. up.

currTime = round(time.time())
startTime = currTime - DURATION


def getEndpoint(metric):
    return f"http://localhost:8082/api/v1/query_range?query={metric}&start={startTime}&end={currTime}&step={INTERVAL}"


response = requests.get(getEndpoint(memory_metric))
results = response.json()['data']['result'][0]['values']
items = defaultdict(list)

for i in range(startTime, currTime+1):
    items[i] = [-1, -1, -1]

for row in results:
    items[row[0]][0] = row[1]

response = requests.get(getEndpoint(cpu_metric))
results = response.json()['data']['result'][0]['values']
for row in results:
    items[row[0]][1] = row[1]

response = requests.get(getEndpoint(avg_req_metric))
results = response.json()['data']['result'][0]['values']
for row in results:
    items[row[0]][2] = row[1]


with open('results/results.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    _ = writer.writerow(
        ["starttime", "endtime", "avg_memory", "avg_cpu", "avg_req"])
    for item in items:
        _ = writer.writerow([item[0], item[0]+INTERVAL,
                             item[1], item[2], item[3]])

import time
import csv
import requests

DURATION = 600  # 600 seconds
INTERVAL = 1  # 1 second

memory_metric = 'avg(nginx_ingress_controller_nginx_process_resident_memory_bytes{controller_pod=~".*",controller_class=~".*",controller_namespace=~".*"})'
cpu_metric = 'avg(rate(nginx_ingress_controller_nginx_process_cpu_seconds_total{controller_pod=~".*",controller_class=~".*",controller_namespace=~".*"}[2m]))'
avg_req_metric = 'avg(irate(nginx_ingress_controller_requests{controller_pod=~".*",controller_class=~".*",controller_namespace=~".*",ingress=~".*"}[2m]))'

# There will always be only 1 array as we are summing all ingress / service etc. up.

currTime = time.time()
startTime = currTime - DURATION


def getEndpoint(metric):
    return f"http://localhost:8082/api/v1/query_range?query=avg({metric})&start={startTime}&end={currTime}&step={INTERVAL}"


response = requests.get(getEndpoint(memory_metric))
results = response.json()['data']['result'][0]['values']

items = []
for row in results:
    items.append(row)

response = requests.get(getEndpoint(cpu_metric))
results = response.json()['data']['result'][0]['values']

for idx, val in enumerate(results):
    items[idx].append(val[1])

response = requests.get(getEndpoint(avg_req_metric))
results = response.json()['data']['result'][0]['values']
for idx, val in enumerate(results):
    items[idx].append(val[1])

with open('results/results.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    _ = writer.writerow(
        ["starttime", "endtime", "avg_memory", "avg_cpu", "avg_req"])
    for item in items:
        _ = writer.writerow([item[0], item[0]+INTERVAL,
                             item[1], item[2], item[3]])

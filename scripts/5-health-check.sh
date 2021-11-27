#!/bin/bash

echo "--- 5. HealthCheck for FOO BAR App ---"

### Checking if bar is working
curl localhost/bar

### Checking if foo is working
curl localhost/foo

### Check if ingress is normal
# Not too sure on what is expected, see README.md

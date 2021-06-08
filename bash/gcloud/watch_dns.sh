#!/bin/bash
url="https://dns.google/resolve?name=central-dashboard.non-prod.${GCP_WORKSPACE_DOMAIN_NAME}&type=A"
command="curl -s '${url}' | jq '.Answer'"
watch -d -n 2 "${command}"

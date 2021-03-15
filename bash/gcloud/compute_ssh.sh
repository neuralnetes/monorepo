#!/bin/bash
project_id="${1}"
vm_name="${2}"
gcloud compute ssh "${vm_name}" \
  --project="${project_id}"

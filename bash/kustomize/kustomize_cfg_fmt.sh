#!/bin/bash
find . -type d \
  -not -path "*/kubeflow/1.2/base/*" \
  -maxdepth 1 \
  -mindepth 1 | while read -r dir_path; do
  kustomize cfg fmt "${dir_path}"
done
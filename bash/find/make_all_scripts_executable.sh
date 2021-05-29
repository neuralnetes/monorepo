#!/bin/bash
directory_path="${1}"
find "${directory_path}" -type f \
  -maxdepth 1 \
  -mindepth 1 | while read -r file_path; do
  if [[ "${file_path: -3}" == ".sh"  ]]; then
    chmod +x "${file_path}"
  fi
done
#!/bin/bash
directory_path="${1}"
find "${directory_path}" -type f \
  -not -path "*/README.md" \
  -maxdepth 1 \
  -mindepth 1 | while read -r file_path; do
  if [[ "${file_path: -3}" != ".sh"  ]]; then
      mv "${file_path}" "${file_path}.sh"
  fi
done
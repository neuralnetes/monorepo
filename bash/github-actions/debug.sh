#!/bin/bash
EVENT=$1
EVENT_DATA_RUN=$(echo "${EVENT}" | jq -rc '.data.run')
EVENT_DATA_LOGS=$(echo "${EVENT}" | jq -rc '.data.logs')
EVENT_DATA_ENV=$(echo "${EVENT}" | jq -rc '.data.env')
echo "${EVENT_DATA_RUN}"
gsutil cp "${EVENT_DATA_LOGS}" "${GITHUB_WORKSPACE}/logs.txt"
gsutil cp "${EVENT_DATA_ENV}" "${GITHUB_WORKSPACE}/env.txt"
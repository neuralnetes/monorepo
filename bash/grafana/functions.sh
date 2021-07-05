#!/bin/bash

function get_grafana_dashboards_home() {
  curl -s -H "Authorization: Bearer ${GRAFANA_AUTH}" "https://neuralnetes.grafana.net/api/dashboards/home" \
    | jq
}

function get_grafana_auth() {
  if [[ -z "${GRAFANA_URL}" ]]; then
    GRAFANA_URL=""
  fi
  echo "${GRAFANA_URL}"
}

function get_grafana_url() {
  if [[ -z "${GRAFANA_URL}" ]]; then
    GRAFANA_URL="https://neuralnetes.grafana.net"
  fi
  echo "${GRAFANA_URL}"
}

function get_grafana_org_id() {
  if [[ -z "${GRAFANA_ORG_ID}" ]]; then
    GRAFANA_ORG_ID="1"
  fi
  echo "${GRAFANA_ORG_ID}"
}

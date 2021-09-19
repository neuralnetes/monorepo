#!/bin/bash
function setup_jenv() {
  if [[ ! -d "${JENV_ROOT}" ]]; then
    git clone https://github.com/jenv/jenv.git "${JENV_ROOT}"
  fi
}

function setup_java_versions() {
  if [[ ! -d "${JENV_ROOT}/jvms" ]]; then
    mkdir -p "${JENV_ROOT}/jvms"
  fi

  if [[ ! -d "${JENV_ROOT}/jvms/jdk-16.0.2+7" ]]; then
    wget "https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2%2B7/OpenJDK16U-jdk_x64_mac_hotspot_16.0.2_7.tar.gz"
    tar xvfz OpenJDK16U-jdk_x64_mac_hotspot_16.0.2_7.tar.gz
    rm -rf OpenJDK16U-jdk_x64_mac_hotspot_16.0.2_7.tar.gz
    mv jdk-16.0.2+7 "${JENV_ROOT}/jvms"
    jenv add "${JENV_ROOT}/jvms/jdk-16.0.2+7/Contents/Home/"
    jenv local openjdk64-16.0.2
  fi
}

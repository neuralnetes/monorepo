#!/bin/bash
OS="darwin"
ARCH="x86_64"
VERSION="google-cloud-sdk-334.0.0"
wget "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${VERSION}-${OS}-${ARCH}.tar.gz" \
  && tar fvxz "${VERSION}-${OS}-${ARCH}.tar.gz" \
  && ./google-cloud-sdk/install.sh -q

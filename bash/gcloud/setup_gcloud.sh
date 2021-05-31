#!/bin/bash
GOOGLE_CLOUD_SDK_ARCHIVE="google-cloud-sdk-342.0.0-linux-x86_64.tar.gz"
curl -O "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GOOGLE_CLOUD_SDK_ARCHIVE}"
tar fvxz "${GOOGLE_CLOUD_SDK_ARCHIVE}"
rm -rf "${GOOGLE_CLOUD_SDK_ARCHIVE}"
mv "google-cloud-sdk" "${HOME}"
ln -s "${HOME}/google-cloud-sdk/bin"/* "${HOME}/.local/bin"

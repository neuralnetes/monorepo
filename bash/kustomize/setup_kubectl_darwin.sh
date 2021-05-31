#!/bin/bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
chmod +x kubectl
mv kubectl "${HOME}/.local/bin"
rm -rf "${HOME}/.kube"
#!/bin/bash
alias kb="kustomize build --load-restrictor LoadRestrictionsNone"
alias kbkaf="kb | kubectl apply -f -"
alias kbkdelf="kb | kubectl delete -f -"
alias kcfmt="kustomize cfg fmt -R"
alias frk="flux reconcile kustomization"

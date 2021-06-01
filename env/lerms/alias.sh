#!/bin/bash
alias kb="kustomize build --load-restrictor LoadRestrictionsNone"
alias kbkaf="kb | kaf -"
alias kbkdelf="kb | kdelf -"
alias kfmt="kustomize cfg fmt -R"
alias to_lowercase="tr '[:upper:]' '[:lower:]'"
alias to_uppercase="tr '[:lower:]' '[:upper:]'"

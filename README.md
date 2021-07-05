# monorepo

#### github actions

[![.github/workflows/workflow-dispatch-terragrunt.yaml](https://github.com/neuralnetes/monorepo/actions/workflows/workflow-dispatch-terragrunt.yaml/badge.svg)](https://github.com/neuralnetes/monorepo/actions/workflows/workflow-dispatch-terragrunt.yaml)

#### setup

```
mkdir -p "${HOME}/.local/bin"
export PATH="${HOME}/.local/bin:${PATH}"
export OS="darwin"
export ARCH="arm64"
export GITHUB_WORKSPACE=$(git rev-parse --show-toplevel)
export GITHUB_USERNAME=lerms
export GITHUB_NAME="Alexander Lerma"
export GITHUB_EMAIL="alexander.lerma@neuralnetes.com"
source "${GITHUB_WORKSPACE}/bash/workspace/${OS}-${ARCH}/.envrc-root"
setup_workspace
source "${HOME}/.zshrc"
```

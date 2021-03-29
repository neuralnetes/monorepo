# environment

# create a workspace for your github user

```
export GITHUB_WORKSPACE="${HOME}/go/src/github.com/neuralnetes/monorepo"
export GITHUB_USER="lerms"
export GITHUB_USER_WORKSPACE="${GITHUB_WORKSPACE}/bash/workspace/${GITHUB_USER}"
source "${GITHUB_USER_WORKSPACE}/.zshrc"
```
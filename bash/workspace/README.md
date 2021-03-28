# environment

# create a workspace for your github user

```
GITHUB_ORGANIZATION="neuralnetes"
GITHUB_REPOSITORY="${GITHUB_ORGANIZATION}/monorepo"
GITHUB_WORKSPACE="${HOME}/go/src/github.com/${GITHUB_REPOSITORY}"
GITHUB_USER=lerms
GITHUB_USER_WORKSPACE="${GITHUB_WORKSPACE}/bash/workspace/${GITHUB_USER}"
ln -fs "${GITHUB_WORKSPACE}/bash/workspace/${GITHUB_USER}"/.* "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_WORKSPACE}/bash/workspace/${GITHUB_USER}"/* "${GITHUB_WORKSPACE}"
source "${HOME}/.zshrc"
direnv allow "${HOME}/.envrc"
direnv allow "${GITHUB_WORKSPACE}/.envrc"
```
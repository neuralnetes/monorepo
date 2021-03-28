# environment

```
GITHUB_WORKSPACE="${HOME}/go/src/github.com/neuralnetes/monorepo"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/.* "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/.envrc "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/* "${GITHUB_WORKSPACE}"
source "${HOME}/.zshrc"
direnv allow "${HOME}/.envrc"
direnv allow "${GITHUB_WORKSPACE}/.envrc"
```
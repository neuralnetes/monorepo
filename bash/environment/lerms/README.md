# environment

```
GITHUB_WORKSPACE="${HOME}/go/src/github.com/neuralnetes/monorepo"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/.* "${HOME}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/.envrc "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_WORKSPACE}/bash/environment/lerms"/* "${HOME}"
source "${HOME}/.zshrc"
direnv allow "${HOME}/.envrc"
direnv allow "${GITHUB_WORKSPACE}/.envrc"
```
# environment

# create a workspace for your github user

```
export GITHUB_WORKSPACE=/Users/alexanderlerma/go/src/github.com/neuralnetes/monorepo
export GITHUB_USER_WORKSPACE="${GITHUB_WORKSPACE}/bash/workspace/lerms"
ln -fs "${GITHUB_USER_WORKSPACE}"/.envrc* "${GITHUB_WORKSPACE}"
ln -fs "${GITHUB_USER_WORKSPACE}"/.* "${HOME}"
ln -fs "${GITHUB_USER_WORKSPACE}"/* "${HOME}"
```
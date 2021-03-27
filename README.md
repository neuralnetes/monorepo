# monorepo

[![.github/workflows/terragrunt.yaml](https://github.com/neuralnetes/monorepo/actions/workflows/terragrunt.yaml/badge.svg?branch=main)](https://github.com/neuralnetes/monorepo/actions/workflows/terragrunt.yaml)

#### [terragrunt/live/gcs/non-prod](./terragrunt/live/gcs/non-prod)

```
GITHUB_REF=main \
IAM=true \
SECRET=true \
NETWORK=true \
DATA=true \
COMPUTE=true \
SHARED=true \
TERRAGRUNT_WORKING_DIR=terragrunt/live/gcs/non-prod \
TERRAGRUNT_COMMAND='apply' \
./bash/github-actions/workflow_dispatch_terragrunt.sh
```

will trigger a `workflow_dispatch` event with this request

```
{
  "ref": "main",
  "inputs": {
    "network": "true",
    "secret": "true",
    "iam": "true",
    "data": "true",
    "compute": "true",
    "shared": "true",
    "terragrunt_working_dir": "terragrunt/live/gcs/non-prod",
    "terragrunt_command": "apply"
  }
}
```
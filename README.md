# monorepo

#### github actions

[![.github/workflows/workflow-dispatch-terragrunt.yaml](https://github.com/neuralnetes/monorepo/actions/workflows/workflow-dispatch-terragrunt.yaml/badge.svg)](https://github.com/neuralnetes/monorepo/actions/workflows/workflow-dispatch-terragrunt.yaml)

```shell script
./bash/github-actions/workflow_dispatch_terragrunt.sh
```

would trigger a `workflow_dispatch` event with this request

```json
{
  "ref": "main",
  "inputs": {
    "terragrunt_working_dir": "terragrunt/live/gcs/non-prod",
    "terragrunt_command": "run-all apply",
    "terragrunt_cli_flags": "[\"--terragrunt-include-dir global/terraform/**/**\",\"--terragrunt-include-dir global/iam/**/**\",\"--terragrunt-include-dir global/secret/**/**\",\"--terragrunt-include-dir global/network/**/**\",\"--terragrunt-include-dir global/data/**/**\",\"--terragrunt-include-dir global/compute/**/**\",\"--terragrunt-include-dir us-central1/network/**/**\",\"--terragrunt-include-dir us-central1/data/**/**\",\"--terragrunt-include-dir us-central1/compute/**/**\"]"
  }
}
```
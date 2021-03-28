# monorepo

[![.github/workflows/terragrunt.yaml](https://github.com/neuralnetes/monorepo/actions/workflows/terragrunt.yaml/badge.svg?branch=main)](https://github.com/neuralnetes/monorepo/actions/workflows/terragrunt.yaml)

#### [terragrunt/live/gcs/non-prod](./terragrunt/live/gcs/non-prod)

running

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
    "terragrunt_cli_flags": "--terragrunt-include-dir \"global/compute/**/**\" \\\n  --terragrunt-include-dir \"global/data/**/**\" \\\n  --terragrunt-include-dir \"global/iam/**/**\" \\\n  --terragrunt-include-dir \"global/network/**/**\" \\\n  --terragrunt-include-dir \"global/secret/**/**\" \\\n  --terragrunt-include-dir \"global/terraform/**/**\" \\\n  --terragrunt-include-dir \"us-central1/compute/**/**\" \\\n  --terragrunt-include-dir \"us-central1/data/**/**\" \\\n  --terragrunt-include-dir \"us-central1/network/**/**\""
  }
}
```
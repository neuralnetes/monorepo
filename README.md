# monorepo

#### setup workspace

```
export GITHUB_WORKSPACE=$(git rev-parse --show-toplevel)
export GITHUB_USERNAME=lerms
bash "${GITHUB_WORKSPACE}/workspace/base/setup.sh"
```

#### github actions

[![.github/workflows/workflow-dispatch-terragrunt.yaml](https://github.com/neuralnetes/monorepo/actions/workflows/workflow-dispatch-terragrunt.yaml/badge.svg)](https://github.com/neuralnetes/monorepo/actions/workflows/workflow-dispatch-terragrunt.yaml)

```shell script
bash bash/github/workflow_dispatch_terragrunt.sh
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

```shell script
bash bash/github/workflow_dispatch_generate_kubeflow_cluster.sh
```

would trigger a `workflow_dispatch` event with this request

```json
{
  "ref": "main",
  "inputs": {
    "cluster_name": "cluster-cklf",
    "compute_project": "compute-cklf",
    "cluster_location": "us-central1-a",
    "iam_project": "iam-cklf",
    "kubeflow_project": "kubeflow-cklf",
    "network_project": "network-cklf",
    "secret_project": "secret-cklf"
  }
}
```


```shell script
bash bash/github/workflow_dispatch_kustomize_build_kubectl_apply.sh
```

would trigger a `workflow_dispatch` event with this request

```json
{
  "ref": "main",
  "inputs": {
    "cluster_name": "cluster-cklf",
    "cluster_location": "us-central1-a",
    "cluster_project": "kubeflow-cklf"
  }
}
```

#### debug

copy github event json message posted in slack `#github` channel

```shell script
EVENT="$(pbpaste)"
bash bash/github/debug.sh "${EVENT}"
```

an explicit example without `pbpaste` would look like ...

```shell script
EVENT='{"type":"github_actions","data":{"status":"failure","logs":"gs://terraform-neuralnetes/2baf3faf06a907054af376aaac71e0a2789ce860/logs.txt","run":"https://github.com/neuralnetes/monorepo/actions/runs/889505371","env":"gs://terraform-neuralnetes/2baf3faf06a907054af376aaac71e0a2789ce860/env.txt"}}'
bash bash/github/debug.sh "${EVENT}"
```

this will print out log messages that container keyword "error".

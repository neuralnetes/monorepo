# monorepo

# infra-live

![.github/workflows/terragrunt-run-all.yaml](https://github.com/neuralnetes/infra-live/workflows/.github/workflows/terragrunt-run-all.yaml/badge.svg?branch=master)

live terraform infrastructure that manages multiple deployment environments using terragrunt.

### dependencies

#### setup gloud

```shell script
brew install --cask google-cloud-sdk
```

#### setup path

```
export HOME_BIN="${HOME}/bin"
mkdir -p "${HOME_BIN}"
export PATH="${HOME_BIN}:${PATH}"
```


#### install terragrunt via tgenv

```
git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
ln -s ~/.tgenv/bin/* "${HOME_BIN}"
tgenv install
```

#### environment variables

```
GCP_BILLING_ACCOUNT
GCP_ORG
GCP_ORG_ID
GCP_PROJECT_ID
GCS_TERRAFORM_REMOTE_STATE_BUCKET
GCS_TERRAFORM_REMOTE_STATE_LOCATION
GITHUB_TOKEN
GITHUB_REPOSITORY
GITHUB_ORGANIZATION
TERRAFORM_CLOUD_ORGANIZATION
TERRAFORM_CLOUD_TOKEN
```

#### terragrunt run-all

[terragrunt-run-all](https://github.com/neuralnetes/infra-live/actions/workflows/terragrunt-run-all.yaml)

##### apply

```shell script
./bash/github-actions/workflow_dispatch_infra_live_terragrunt_run_all.sh "$GH_USER_TOKEN" "master" "./live/gcs/non-prod" "apply" "true" "true" "true" "true" "true" "true"
```

##### destroy

```shell script
./bash/github-actions/workflow_dispatch_infra_live_terragrunt_run_all.sh "$GH_USER_TOKEN" "master" "./live/gcs/non-prod" "destroy" "true" "true" "true" "true" "true" "true"
```

##### gcloud_delete_projects

```shell script
./bash/github-actions/workflow_dispatch_gcloud_projects_delete.sh "$GH_USER_TOKEN" "master" "./live/gcs/non-prod" "destroy" "true" "true" "true" "true" "true" "true" "true"
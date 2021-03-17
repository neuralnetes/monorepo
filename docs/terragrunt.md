# terragrunt

* [docs](https://terragrunt.gruntwork.io/docs/)
* [cli-options](https://terragrunt.gruntwork.io/docs/reference/cli-options/)
* [built-in-functions](https://terragrunt.gruntwork.io/docs/reference/built-in-functions/)
* [keep-your-remote-state-configuration-dry](https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/)
* [execute-terraform-commands-on-multiple-modules-at-once](https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/)
* [dependencies-between-modules](https://terragrunt.gruntwork.io/docs/features/execute-terraform-commands-on-multiple-modules-at-once/#dependencies-between-modules)
* [caching](https://terragrunt.gruntwork.io/docs/features/caching/)

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

[terragrunt-run-all](https://github.com/neuralnetes/monorepo/actions/workflows/terragrunt-run-all.yaml)

##### apply

```shell script
./bash/github-actions/workflow_dispatch_terragrunt.sh
```

##### destroy

```shell script
./bash/github-actions/workflow_dispatch_terragrunt.sh
```

##### gcloud_delete_projects

```shell script
./bash/github-actions/workflow_dispatch_gcloud_projects_delete.sh
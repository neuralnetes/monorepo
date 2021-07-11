terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/secret-manager-secrets?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "secret_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/secret/google/project"
}

dependency "service_account_keys" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-keys"
}

dependency "cloud_sqls" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/data/google/cloud-sqls"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/shared/global/shared/random/random-string"
}

inputs = {
  secret_manager_secrets = [
    {
      project_id = dependency.secret_project.outputs.project_id
      secret_id  = "env-${dependency.random_string.outputs.result}"
      secret_data = jsonencode({
        GOOGLE_CLIENT_ID      = get_env("GOOGLE_CLIENT_ID")
        GOOGLE_CLIENT_SECRET  = get_env("GOOGLE_CLIENT_SECRET")
        GITHUB_CLIENT_ID      = get_env("GITHUB_CLIENT_ID")
        GITHUB_CLIENT_SECRET  = get_env("GITHUB_CLIENT_SECRET")
        KUBEFLOW_USER_EMAILS  = get_env("KUBEFLOW_USER_EMAILS")
        KUBEFLOW_ADMIN_EMAILS = get_env("KUBEFLOW_ADMIN_EMAILS")
        SHARED_PROJECT        = get_env("GCP_PROJECT_ID")
        IAM_PROJECT           = "iam-${dependency.random_string.outputs.result}"
        DNS_PROJECT           = "dns-${dependency.random_string.outputs.result}"
        SECRET_PROJECT        = "secret-${dependency.random_string.outputs.result}"
        NETWORK_PROJECT       = "network-${dependency.random_string.outputs.result}"
        DATA_PROJECT          = "data-${dependency.random_string.outputs.result}"
        KUBEFLOW_PROJECT      = "kubeflow-${dependency.random_string.outputs.result}"
        MANAGEMENT_PROJECT    = "management-${dependency.random_string.outputs.result}"
        ARTIFACT_PROJECT      = "artifact-${dependency.random_string.outputs.result}"
      })
      replication = {
        automatic = true
      }
    },
    {
      project_id = dependency.secret_project.outputs.project_id
      secret_id  = "kubeflow-${dependency.random_string.outputs.result}-kubeflow-katib-mysql-secrets"
      secret_data = jsonencode({
        MYSQL_HOST          = dependency.cloud_sqls.outputs.mysqls_map["kubeflow-${dependency.random_string.outputs.result}-mssql-01"].mysql.private_ip_address
        MYSQL_PORT          = "3306"
        MYSQL_USER          = dependency.cloud_sqls.outputs.mysqls_map["kubeflow-${dependency.random_string.outputs.result}-mssql-01"].default_user.name
        MYSQL_PASSWORD      = dependency.cloud_sqls.outputs.mysqls_map["kubeflow-${dependency.random_string.outputs.result}-mssql-01"].default_user.password
        MYSQL_ROOT_PASSWORD = dependency.cloud_sqls.outputs.mysqls_map["kubeflow-${dependency.random_string.outputs.result}-mssql-01"].default_user.password
      })
      replication = {
        automatic = true
      }
    },
    {
      project_id  = dependency.secret_project.outputs.project_id
      secret_id   = "kubeflow-${dependency.random_string.outputs.result}-cert-manager-service-account-key"
      secret_data = dependency.service_account_keys.outputs.service_account_keys_map["cert-manager"].private_key
      replication = {
        automatic = true
      }
    },
    {
      project_id = dependency.secret_project.outputs.project_id
      secret_id  = "kubeflow-${dependency.random_string.outputs.result}-auth-dex-secrets"
      secret_data = jsonencode({
        GOOGLE_CLIENT_ID     = get_env("GOOGLE_CLIENT_ID")
        GOOGLE_CLIENT_SECRET = get_env("GOOGLE_CLIENT_SECRET")
        GITHUB_CLIENT_ID     = get_env("GITHUB_CLIENT_ID")
        GITHUB_CLIENT_SECRET = get_env("GITHUB_CLIENT_SECRET")
      })
      replication = {
        automatic = true
      }
    },
    {
      project_id  = dependency.secret_project.outputs.project_id
      secret_id   = "kubeflow-${dependency.random_string.outputs.result}-auth-service-account-key"
      secret_data = dependency.service_account_keys.outputs.service_account_keys_map["auth"].private_key
      replication = {
        automatic = true
      }
    }
  ]
}
terraform {
  source = "github.com/neuralnetes/monorepo.git//terraform/modules/google/secret-manager-secrets?ref=main"
}

include {
  path = find_in_parent_folders()
}

dependency "secret_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/secret/google/project"
}

dependency "compute_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/compute/google/project"
}

dependency "kubeflow_project" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/kubeflow/google/project"
}

dependency "project_iam_bindings" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/project-iam-bindings"
}

dependency "service_account_keys" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/service-account-keys"
}

dependency "oauths" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/iam/google/oauths"
}

dependency "cloud_sqls" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/us-central1/data/google/cloud-sqls"
}

dependency "random_string" {
  config_path = "${get_parent_terragrunt_dir()}/non-prod/global/terraform/random/random-string"
}

inputs = {
  secret_manager_secrets = [
    {
      project_id  = dependency.secret_project.outputs.project_id
      secret_id   = "random-${dependency.random_string.outputs.result}"
      secret_data = dependency.random_string.outputs.result
      replication = {
        automatic = true
      }
    },
    {
      project_id = dependency.secret_project.outputs.project_id
      secret_id  = "${dependency.kubeflow_project.outputs.project_id}-kubeflow-katib-mysql-secrets"
      secret_data = jsonencode({
        MYSQL_HOST          = dependency.cloud_sqls.outputs.mysqls_map["cloud-sql-${dependency.random_string.outputs.result}"].mysql.private_ip_address
        MYSQL_PORT          = "5432"
        MYSQL_USER          = dependency.cloud_sqls.outputs.mysqls_map["cloud-sql-${dependency.random_string.outputs.result}"].default_user.name
        MYSQL_PASSWORD      = dependency.cloud_sqls.outputs.mysqls_map["cloud-sql-${dependency.random_string.outputs.result}"].default_user.password
        MYSQL_ROOT_PASSWORD = dependency.cloud_sqls.outputs.mysqls_map["cloud-sql-${dependency.random_string.outputs.result}"].default_user.password
      })
      replication = {
        automatic = true
      }
    },
    {
      project_id = dependency.secret_project.outputs.project_id
      secret_id  = "${dependency.kubeflow_project.outputs.project_id}-cert-manager-service-account-key"
      secret_data = jsonencode({
        "key.json" = dependency.service_account_keys.outputs.service_account_keys_map["cert-manager"].private_key
      })
      replication = {
        automatic = true
      }
    },
    {
      project_id = dependency.secret_project.outputs.project_id
      secret_id  = "${dependency.kubeflow_project.outputs.project_id}-auth-dex-secrets"
      secret_data = jsonencode({
        GOOGLE_CLIENT_ID     = dependency.oauths.outputs.clients_map["dex"].client_id
        GOOGLE_CLIENT_SECRET = dependency.oauths.outputs.clients_map["dex"].secret
      })
      replication = {
        automatic = true
      }
    },
    {
      project_id = dependency.secret_project.outputs.project_id
      secret_id  = "${dependency.kubeflow_project.outputs.project_id}-auth-service-account-key"
      secret_data = jsonencode({
        "key.json" = dependency.service_account_keys.outputs.service_account_keys_map["dex-auth"].private_key
      })
      replication = {
        automatic = true
      }
    }
  ]
}
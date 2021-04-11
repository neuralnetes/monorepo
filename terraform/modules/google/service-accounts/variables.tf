variable "service_accounts" {
  type = list(object({
    project_id    = string
    name          = string
    project_roles = list(string)
    //    grant_billing_role = bool
    //    billing_account_id = string
    //    grant_xpn_roles = bool
    //    org_id = string
    //    generate_keys = bool
    //    display_name = string
    //    description = string
  }))
}

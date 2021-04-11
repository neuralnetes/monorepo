variable "secret_id" {
  type = string
}
variable "project_id" {
  type = string
}
variable "secret_data" {
  type = string
}
variable "replication" {
  type = object({
    automatic = bool
  })
}

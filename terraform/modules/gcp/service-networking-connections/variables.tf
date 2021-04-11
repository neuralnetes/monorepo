variable "network" {
  type = string
}
variable "service" {
  type = string
  default = "servicenetworking.googleapis.com"
}
variable "reserved_peering_ranges" {
  default = []
}

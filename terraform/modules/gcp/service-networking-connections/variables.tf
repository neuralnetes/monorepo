variable "service_networking_connections" {
  type = list(object({
    network                 = string
    service                 = string
    reserved_peering_ranges = list(string)
  }))
  default = []
}

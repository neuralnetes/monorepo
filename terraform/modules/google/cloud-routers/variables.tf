variable "cloud_routers" {
  type = list(object({
    name    = string
    project = string
    network = string
    bgp = object({
      asn               = string
      advertised_groups = list(string)
    })
    name   = string
    region = string
  }))
}
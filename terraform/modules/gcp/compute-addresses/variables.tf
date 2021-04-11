variable "regional_addresses" {
  type = list(object({
    name          = string
    purpose       = string
    address_type  = string
    subnetwork    = string
    labels        = map
  }))
  default = []
}

variable "global_addresses" {
  type = list(object({
    name          = string
    purpose       = string
    address_type  = string
    prefix_length = number
    network       = string
  }))
  default = []
}
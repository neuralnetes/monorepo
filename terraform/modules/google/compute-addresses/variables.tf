variable "regional_addresses" {
  type    = list(map(string))
  default = []
}

variable "global_addresses" {
  type = list(object({
    project       = string
    name          = string
    purpose       = string
    address_type  = string
    prefix_length = number
    network       = string
  }))
  default = []
}
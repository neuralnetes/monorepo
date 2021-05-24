locals {
  tags_map = {
    random_string       = var.random_string
    owner               = var.owner
    public              = "public"
    public_restricted   = "public-restricted"
    private             = "private"
    private_persistence = "private-persistence"
    openvpn             = "openvpn"
  }
}

data "null_data_source" "tags" {
  inputs = {
    random_string       = var.random_string
    owner               = var.owner
    public              = "public"
    public_restricted   = "public-restricted"
    private             = "private"
    private_persistence = "private-persistence"
  }
}

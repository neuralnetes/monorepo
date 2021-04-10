variable "bigquery_datasets" {
  type = list(object({
    dataset_id                 = string
    location                   = string
    project_id                 = string
    delete_contents_on_destroy = bool
    tables = list(object({
      table_id   = string,
      schema     = string,
      clustering = list(string),
      time_partitioning = object({
        expiration_ms            = string,
        field                    = string,
        type                     = string,
        require_partition_filter = bool,
      }),
      expiration_time = string,
      labels          = map(string),
    }))
    views = list(object({
      view_id        = string,
      query          = string,
      use_legacy_sql = bool,
      labels         = map(string),
    }))
  }))
}

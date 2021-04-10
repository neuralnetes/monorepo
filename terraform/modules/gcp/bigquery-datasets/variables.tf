variable "bigquery_datasets" {
  type = list(object({
    dataset_id = string
    location   = string
    project_id = string
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
      range_partitioning = object({
        field = string,
        range = object({
          start    = string,
          end      = string,
          interval = string,
        }),
      }),
      expiration_time = string,
      labels          = map(string),
    }))
  }))
}

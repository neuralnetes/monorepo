variable "datasets" {
  type = list(object({
    dataset_id                 = string
    dataset_name               = string
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
    views = list(object({
      view_id        = string,
      query          = string,
      use_legacy_sql = bool,
      labels         = map(string),
    }))
    external_tables = list(object({
      table_id              = string,
      autodetect            = bool,
      compression           = string,
      ignore_unknown_values = bool,
      max_bad_records       = number,
      schema                = string,
      source_format         = string,
      source_uris           = list(string),
      csv_options = object({
        quote                 = string,
        allow_jagged_rows     = bool,
        allow_quoted_newlines = bool,
        encoding              = string,
        field_delimiter       = string,
        skip_leading_rows     = number,
      }),
      google_sheets_options = object({
        range             = string,
        skip_leading_rows = number,
      }),
      hive_partitioning_options = object({
        mode              = string,
        source_uri_prefix = string,
      }),
      expiration_time = string,
      labels          = map(string),
    }))
  }))
}
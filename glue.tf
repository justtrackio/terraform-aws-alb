locals {
  glue_table_name    = replace(module.glue_label.id, "-", "_")
  glue_database_name = var.glue_database_name != null ? var.glue_database_name : "${module.this.organizational_unit}_alb_logs"
}

resource "aws_glue_catalog_table" "this" {
  provider      = aws.glue
  count         = var.access_logs_enabled ? 1 : 0
  name          = local.glue_table_name
  database_name = local.glue_database_name
  table_type    = "EXTERNAL_TABLE"

  partition_keys {
    name = "day"
    type = "string"
  }

  parameters = {
    "projection.enabled"           = "true",
    "projection.day.type"          = "date",
    "projection.day.range"         = "2023/09/01,NOW", #logging part is implemented at Sept 2023
    "projection.day.format"        = "yyyy/MM/dd",
    "projection.day.interval"      = "1",
    "projection.day.interval.unit" = "DAYS",
    "storage.location.template"    = "${local.access_logs_location}/$${day}"
  }

  storage_descriptor {
    location      = local.access_logs_location
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "${module.this.namespace}_${replace((var.name), "-", "_")}"
      serialization_library = "org.apache.hadoop.hive.serde2.RegexSerDe"

      parameters = {
        "serialization.format" = 1
        "input.regex"          = "([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) (.*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-_]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^s]+?)\" \"([^s]+)\" \"([^ ]*)\" \"([^ ]*)\""
      }
    }

    columns {
      name = "type"
      type = "string"
    }

    columns {
      name = "time"
      type = "string"
    }

    columns {
      name = "elb"
      type = "string"
    }

    columns {
      name = "client_ip"
      type = "string"
    }

    columns {
      name = "client_port"
      type = "int"
    }

    columns {
      name = "target_ip"
      type = "string"
    }

    columns {
      name = "target_port"
      type = "int"
    }

    columns {
      name = "request_processing_time"
      type = "double"
    }

    columns {
      name = "target_processing_time"
      type = "double"
    }

    columns {
      name = "response_processing_time"
      type = "double"
    }

    columns {
      name = "elb_status_code"
      type = "int"
    }

    columns {
      name = "target_status_code"
      type = "string"
    }

    columns {
      name = "received_bytes"
      type = "bigint"
    }

    columns {
      name = "sent_bytes"
      type = "bigint"
    }

    columns {
      name = "request_verb"
      type = "string"
    }

    columns {
      name = "request_url"
      type = "string"
    }

    columns {
      name = "request_proto"
      type = "string"
    }

    columns {
      name = "user_agent"
      type = "string"
    }

    columns {
      name = "ssl_cipher"
      type = "string"
    }

    columns {
      name = "ssl_protocol"
      type = "string"
    }

    columns {
      name = "target_group_arn"
      type = "string"
    }

    columns {
      name = "trace_id"
      type = "string"
    }

    columns {
      name = "domain_name"
      type = "string"
    }

    columns {
      name = "chosen_cert_arn"
      type = "string"
    }

    columns {
      name = "matched_rule_priority"
      type = "string"
    }

    columns {
      name = "request_creation_time"
      type = "string"
    }

    columns {
      name = "actions_executed"
      type = "string"
    }

    columns {
      name = "redirect_url"
      type = "string"
    }

    columns {
      name = "lambda_error_reason"
      type = "string"
    }

    columns {
      name = "target_port_list"
      type = "string"
    }

    columns {
      name = "target_status_code_list"
      type = "string"
    }

    columns {
      name = "classification"
      type = "string"
    }

    columns {
      name = "classification_reason"
      type = "string"
    }
  }
}

terraform {
  required_providers {
    snowflake = {
      source                = "chanzuckerberg/snowflake"
      configuration_aliases = [snowflake.ACCOUNTADMIN]
    }
    time = {}
  }
}

resource "snowflake_warehouse" "warehouse" {
  // Only ACCOUNTADMIN can assign warehouses to resource monitors
  provider = snowflake.ACCOUNTADMIN

  name             = local.name
  comment          = var.comment
  warehouse_size   = var.warehouse_size
  resource_monitor = snowflake_resource_monitor.monitor.name

  auto_suspend = var.auto_suspend
}

resource "time_offset" "monitor_start_time" {
  // a stable timestamp stored in the tf state to
  // used to avoid perpetual differences and resource recreation

  // start time needs to be in the future
  offset_days = 1
}

resource "snowflake_resource_monitor" "monitor" {
  provider = snowflake.ACCOUNTADMIN

  name         = "${local.name}_MONITOR"
  credit_quota = var.credit_quota

  frequency = var.frequency

  // start at today midnight
  // NB: this is UTC midnight not local midnight
  start_timestamp = formatdate(
    "YYYY-MM-DD 00:00",
    time_offset.monitor_start_time.rfc3339
  )

  notify_triggers = [80]
}

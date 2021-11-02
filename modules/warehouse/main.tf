terraform {
  required_providers {
    snowflake = {
      source                = "chanzuckerberg/snowflake"
      configuration_aliases = [snowflake.ACCOUNTADMIN, snowflake.SECURITYADMIN]
    }
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

resource "snowflake_resource_monitor" "monitor" {
  provider = snowflake.ACCOUNTADMIN

  name         = "${local.name}_MONITOR"
  credit_quota = var.credit_quota

  frequency = var.frequency

  start_timestamp = "IMMEDIATELY"

  notify_triggers = [80]

  lifecycle {
    ignore_changes = [
      start_timestamp
    ]
  }
}

terraform {
  required_providers {
    snowflake = {
      source                = "chanzuckerberg/snowflake"
      configuration_aliases = [snowflake.SECURITYADMIN]
    }
  }
}

resource "snowflake_warehouse" "warehouse" {
  name             = local.name
  comment          = var.comment
  warehouse_size   = var.warehouse_size
  #resource_monitor = "CUPS_SANDBOX_WH_MONITOR"

  auto_suspend = var.auto_suspend
  #auto_resume  = true
}

# resource "snowflake_resource_monitor" "cups_sandbox_monitor" {
#   provider = snowflake.SYSADMIN

#   name         = "CUPS_SANDBOX_WH_MONITOR"
#   credit_quota = 50

#   frequency       = "WEEKLY"
#   start_timestamp = "IMMEDIATELY"

#   notify_triggers = [80]
# }

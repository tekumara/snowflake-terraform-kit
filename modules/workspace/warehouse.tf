resource "snowflake_resource_monitor" "monitor" {
  provider = snowflake.ACCOUNTADMIN

  name         = "${local.warehouse_name}_MONITOR"
  credit_quota = var.monitor_credit_quota

  frequency = var.monitor_frequency

  start_timestamp = "IMMEDIATELY"

  notify_triggers = [80]

  lifecycle {
    ignore_changes = [
      start_timestamp
    ]
  }
}

resource "snowflake_warehouse" "warehouse" {
  // Only ACCOUNTADMIN can assign warehouses to resource monitors
  provider = snowflake.ACCOUNTADMIN

  name             = local.warehouse_name
  comment          = var.warehouse_comment
  warehouse_size   = var.warehouse_size
  resource_monitor = snowflake_resource_monitor.monitor.name

  auto_suspend = var.warehouse_auto_suspend
}


// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#virtual-warehouse-privileges

resource "snowflake_warehouse_grant" "modify" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "MODIFY"
  roles          = [snowflake_role.admin.name]
}

resource "snowflake_warehouse_grant" "monitor" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "MONITOR"
  roles          = [snowflake_role.admin.name]
}

resource "snowflake_warehouse_grant" "operate" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "OPERATE"
  roles          = [snowflake_role.admin.name]
}

resource "snowflake_warehouse_grant" "usage" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "USAGE"
  roles          = [snowflake_role.admin.name]
}


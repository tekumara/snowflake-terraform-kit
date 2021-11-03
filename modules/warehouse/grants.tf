
// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#virtual-warehouse-privileges

resource "snowflake_warehouse_grant" "modify" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "MODIFY"
  roles          = var.warehouse_roles
}

resource "snowflake_warehouse_grant" "monitor" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "MONITOR"
  roles          = var.warehouse_roles
}

resource "snowflake_warehouse_grant" "operate" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "OPERATE"
  roles          = var.warehouse_roles
}

resource "snowflake_warehouse_grant" "usage" {
  provider = snowflake.SECURITYADMIN

  warehouse_name = snowflake_warehouse.warehouse.name
  privilege      = "USAGE"
  roles          = var.warehouse_roles
}


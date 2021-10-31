
// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#virtual-warehouse-privileges

resource "snowflake_warehouse_grant" "modify" {
  warehouse_name    = local.name
  privilege         = "MODIFY"
  roles             = compact([var.warehouse_role])
}

resource "snowflake_warehouse_grant" "monitor" {
  warehouse_name    = local.name
  privilege         = "MONITOR"
  roles             = compact([var.warehouse_role])
}

resource "snowflake_warehouse_grant" "operate" {
  warehouse_name    = local.name
  privilege         = "OPERATE"
  roles             = compact([var.warehouse_role])
}

resource "snowflake_warehouse_grant" "usage" {
  warehouse_name    = local.name
  privilege         = "USAGE"
  roles             = compact([var.warehouse_role])
}


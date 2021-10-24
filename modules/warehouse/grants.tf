
// reference: https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#virtual-warehouse-privileges

resource "snowflake_warehouse_grant" "modify" {
  warehouse_name    = local.name
  privilege         = "MODIFY"
  roles             = var.warehouse_roles
}

resource "snowflake_warehouse_grant" "monitor" {
  warehouse_name    = local.name
  privilege         = "MONITOR"
  roles             = var.warehouse_roles
}

resource "snowflake_warehouse_grant" "operate" {
  warehouse_name    = local.name
  privilege         = "OPERATE"
  roles             = var.warehouse_roles
}

resource "snowflake_warehouse_grant" "usage" {
  warehouse_name    = local.name
  privilege         = "USAGE"
  roles             = var.warehouse_roles
}


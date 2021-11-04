locals {
  user_name      = upper(var.warehouse_name)
  role_name      = upper(var.warehouse_name)
  database_name  = upper(var.database_name)
  warehouse_name = upper(var.warehouse_name)
}

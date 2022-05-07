locals {
  # used to avoid circular dependency between monitor and warehouse
  warehouse_name = upper(var.warehouse.name)

  database_reader_roles = var.reader_role == null ? [] : coalesce(var.reader_role.grant_to_roles, [])
}

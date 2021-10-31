variable "name" {
  description = "Database name"
  type        = string
}

variable "comment" {
  description = "Database comment"
  type        = string
  default     = null
}

variable "admin_role" {
  description = "Role to assign admin/owner privileges to"
  type = string
  default = ""
}

variable "reader_role" {
  description = "Role to assign read privileges to"
  type = string
  default = ""
}

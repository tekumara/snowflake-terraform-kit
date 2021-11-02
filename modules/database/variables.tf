variable "name" {
  description = "Database name"
  type        = string
}

variable "comment" {
  description = "Database comment"
  type        = string
  default     = null
}

variable "admin_roles" {
  description = "Roles to assign admin privileges to"
  type        = list(string)
  default     = []
}

variable "reader_roles" {
  description = "Roles to assign reader privileges to"
  type        = list(string)
  default     = []
}

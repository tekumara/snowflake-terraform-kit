variable "database_name" {
  description = "Database name"
  type        = string
}

variable "comment" {
  description = "Database comment"
  type        = string
  default     = null
}

variable "admins" {
  description = "Roles to assign admin privleges to"
  type = set(string)
  default = []
}

variable "readers" {
  description = "Roles to assign reader privleges to"
  type = set(string)
  default = []
}

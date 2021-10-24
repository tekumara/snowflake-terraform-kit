variable "name" {
  description = "Database name"
  type        = string
}

variable "comment" {
  description = "Database comment"
  type        = string
  default     = null
}

variable "admins" {
  description = "Roles to assign admin privileges to"
  type = set(string)
  default = []
}

variable "readers" {
  description = "Roles to assign reader privileges to"
  type = set(string)
  default = []
}

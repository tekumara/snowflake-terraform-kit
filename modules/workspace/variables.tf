variable "service_account" {
  type = object({
    user_name               = string
    user_role_grants        = optional(list(string))
    secret_reader_iam_roles = optional(list(string))
    secret_kms_key_id       = string
  })
}

// role

variable "role_name" {
  description = "Role name for the service account user"
  type        = string
}

// database
variable "database" {
  type = object({
    name    = string
    comment = optional(string)
  })
}

variable "database_reader_roles" {
  description = "Roles to assign reader privileges to"
  type        = list(string)
  default     = []
}

variable "warehouse" {
  type = object({
    name                 = string
    size                 = optional(string)
    auto_suspend         = optional(number)
    monitor_credit_quota = optional(number)
    monitor_frequency    = optional(string)
  })

  validation {
    condition     = contains(["null", "MONTHLY", "DAILY", "WEEKLY", "YEARLY", "NEVER"], var.warehouse.monitor_frequency == null ? "null" : var.warehouse.monitor_frequency)
    error_message = "Invalid frequency."
  }

}

// tags
variable "tags" {
  description = "Tags"
  type        = map(any)
  default     = null
}

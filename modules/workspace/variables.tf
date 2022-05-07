variable "service_account" {
  type = object({
    user_name               = string
    user_role_grants        = optional(list(string))
    secret_reader_iam_roles = optional(list(string))
    secret_kms_key_id       = string
  })
}

variable "admin_role" {
  type = object({
    name           = string
    grant_to_users = optional(list(string))
  })
}

variable "reader_role" {
  type = object({
    name           = string
    grant_to_roles = optional(list(string))
  })
  default = null
}

variable "database" {
  type = object({
    name    = string
    comment = optional(string)
  })
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

variable "tags" {
  description = "Tags"
  type        = map(any)
  default     = null
}

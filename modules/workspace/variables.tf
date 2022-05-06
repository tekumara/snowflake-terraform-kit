// user

variable "user_name" {
  description = "User name"
  type        = string
}

variable "user_comment" {
  description = "User comment"
  type        = string
  default     = null
}

// secret

variable "secret_reader_iam_role" {
  description = "AWS IAM role granted access to read the secret (optional)"
  type        = string
  default     = null
}

variable "secret_kms_key_id" {
  description = "KMS key for encrypting the secret"
  type        = string
  default     = null
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

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

variable "secret_reader_role" {
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
variable "database_name" {
  description = "Database name"
  type        = string
}

variable "database_comment" {
  description = "Database comment"
  type        = string
  default     = null
}

variable "database_reader_roles" {
  description = "Roles to assign reader privileges to"
  type        = list(string)
  default     = []
}

// resource monitor

variable "monitor_credit_quota" {
  description = "The number of credits allocated to the resource monitor per frequency interval"
  type        = number
  default     = 50
}

variable "monitor_frequency" {
  description = "The frequency interval at which the credit usage resets to 0"
  type        = string
  default     = "WEEKLY"

  validation {
    condition     = contains(["MONTHLY", "DAILY", "WEEKLY", "YEARLY", "NEVER"], var.monitor_frequency)
    error_message = "Invalid frequency."
  }
}


// warehouse
variable "warehouse_name" {
  description = "Warehouse name"
  type        = string
}

variable "warehouse_comment" {
  description = "Warehouse comment"
  type        = string
  default     = null
}

variable "warehouse_size" {
  description = "Warehouse size"
  type        = string
  default     = "x-small"
}

variable "warehouse_auto_suspend" {
  description = "Auto suspend (seconds)"
  type        = number
  default     = 60
}

// tags
variable "tags" {
  description = "Tags"
  type        = map(any)
  default     = null
}

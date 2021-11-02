// warehouse
variable "name" {
  description = "Warehouse name"
  type        = string
}

variable "comment" {
  description = "Warehouse comment"
  type        = string
  default     = null
}

variable "warehouse_size" {
  description = "Warehouse size"
  type        = string
  default     = "x-small"
}

variable "auto_suspend" {
  description = "Auto suspend (seconds)"
  type        = number
  default     = 60
}

// resource monitor

variable "credit_quota" {
  description = "The number of credits allocated to the resource monitor per frequency interval"
  type        = number
  default     = 50
}

variable "frequency" {
  description = "The frequency interval at which the credit usage resets to 0"
  type        = string
  default     = "WEEKLY"

  validation {
    condition     = contains(["MONTHLY", "DAILY", "WEEKLY", "YEARLY", "NEVER"], var.frequency)
    error_message = "Invalid frequency."
  }
}

variable "warehouse_roles" {
  description = "Roles that can use the warehouse"
  type        = list(string)
  default     = []
}

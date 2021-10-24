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
  type = string
  default = "x-small"
}

variable "auto_suspend" {
  description = "Auto suspend (seconds)"
  type = number
  default = 60
}

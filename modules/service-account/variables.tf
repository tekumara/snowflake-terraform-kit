variable "name" {
  description = "User name"
  type        = string
}

variable "comment" {
  description = "User comment"
  type        = string
  default     = null
}

variable "aws_role_secret_reader" {
  description = "AWS IAM role granted access to read the secret (optional)"
  type        = string
  default     = null
}

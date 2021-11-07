variable "name" {
  description = "User name"
  type        = string
}

variable "comment" {
  description = "User comment"
  type        = string
  default     = null
}

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

variable "name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "description" {
  description = "Description of the IAM policy"
  type        = string
  default     = "Service account policy"
}

variable "policy_json" {
  description = "JSON policy document"
  type        = string
}

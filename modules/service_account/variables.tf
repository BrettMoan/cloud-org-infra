variable "name" {
  description = "Name of the service account (IAM user)"
  type        = string
}

variable "policy_arn" {
  description = "ARN of the policy to attach to the service account"
  type        = string
}

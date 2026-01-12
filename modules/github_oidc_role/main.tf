
variable "repo" { type = string }
variable "name" { type = string }
variable "policy_actions" { type = list(string) }

variable "branch_ref" {
  type        = string
  default     = "refs/heads/main"
  description = "GitHub branch ref to allow in OIDC trust policy."
}

variable "oidc_provider_arn" {
  type        = string
  description = "ARN of the GitHub OIDC provider."
}

resource "aws_iam_role" "this" {
  name = "${var.name}-tf"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.repo}:ref:${var.branch_ref}"
        }
      }
    }]
  })
}


resource "aws_iam_policy" "this" {
  name        = "${var.name}-tf"
  description = "Policy for ${var.name} created by Terraform module."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = var.policy_actions
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

output "role_arn" {
  value = aws_iam_role.this.arn
}

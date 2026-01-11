variable "repo" { type = string }
variable "name" { type = string }
variable "policy_actions" { type = list(string) }

variable "branch_ref" {
  type        = string
  default     = "refs/heads/main"
  description = "GitHub branch ref to allow in OIDC trust policy."
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "this" {
  name = "${var.name}-tf"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
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

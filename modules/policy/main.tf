// Service Account Policy Module
// Creates a custom IAM policy for service accounts

resource "aws_iam_policy" "this" {
  name        = var.name
  description = var.description
  policy      = var.policy_json
}

// Service Account Module
// Creates an IAM user for application service accounts

resource "aws_iam_user" "service_account" {
  name = var.name
}

resource "aws_iam_user_policy_attachment" "service_account_policy" {
  user       = aws_iam_user.service_account.name
  policy_arn = var.policy_arn
}

resource "aws_iam_access_key" "service_account_key" {
  user = aws_iam_user.service_account.name
}

output "access_key_id" {
  value = aws_iam_access_key.service_account_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.service_account_key.secret
  sensitive = true
}

output "access_key_id" {
  description = "Access key ID for the service account"
  value       = aws_iam_access_key.service_account_key.id
}

output "secret_access_key" {
  description = "Secret access key for the service account"
  value       = aws_iam_access_key.service_account_key.secret
  sensitive   = true
}

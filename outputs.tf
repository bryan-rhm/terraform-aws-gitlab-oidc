output "role_arn" {
  description = "Arn of the IAM role allowed to authenticate to AWS from Gitlab CI"
  value       = aws_iam_role.role.arn
}

output "oidc" {
  description = "Gitlab openid connect provider"
  value       = aws_iam_openid_connect_provider.oidc
}

output "assume_role_policy" {
  description = "Assume role policy, this value can be used to create another role outside this module"
  value       = data.aws_iam_policy_document.asume_role_policy.json
}

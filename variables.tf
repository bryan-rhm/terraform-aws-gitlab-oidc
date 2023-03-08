variable "gitlab_tls_url" {
  # Avoid using https scheme because the Hashicorp TLS provider has started following redirects starting v4.
  # See https://github.com/hashicorp/terraform-provider-tls/issues/249
  description = "The TLS URL of the Gitlab provider"
  default     = "tls://gitlab.com:443"
  type        = string

}
variable "gitlab_url" {
  description = "The URL of the Gitlab provider"
  default     = "https://gitlab.com"
  type        = string
}

variable "gitlab_organization" {
  description = "The Gitlab organization/account to allow access to AWS"
  type        = string
}

variable "gitlab_repositories" {
  description = "The Gitlab repositories inside the organization/account you want to allow access to AWS, default all repositories inside the organization"
  default     = ["*"]
  type        = list(string)
}

variable "role_name" {
  description = "Name of the IAM role"
  default     = "GitlabCIRole"
  type        = string
}

variable "managed_policy_arns" {
  description = "The ARNs of the managed policies to attach to the role"
  default     = []
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  default     = {}
  type        = map(string)
}

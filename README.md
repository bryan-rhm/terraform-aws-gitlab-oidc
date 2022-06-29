# Terraform AWS Gitlab OpenId Connect Module

Terraform module that creates an OpenID Connect provider on IAM that allows Gitlab CI pipelines to authenticate in your AWS account.

### Install the module

Initialize the module and get the Role ARN from the outputs.

```hcl
provider "aws" {
  region = var.region
}

module "gitlab_oidc" {
  source  = "bryan-rhm/gitlab-oidc/aws"
  version = "choose the version you need"

  gitlab_organization = "YOUR ORGANIZATION/GITLAB ACCOUNT"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"] # Policies you want to attach to the pipeline role.

}

# Role ARN can be accessed with: module.gitlab_oidc.role_arn

```

Once you have installed the module you will be able authenticate from your gitlab organization using the role created from the module.

After you configure the OIDC and role, the GitLab CI/CD job can retrieve a temporary credential from AWS Security Token Service (STS).

```yaml
assume role:
  script:
    - >
      STS=($(aws sts assume-role-with-web-identity
      --role-arn ${ROLE_ARN}
      --role-session-name "GitLabRunner-${CI_PROJECT_ID}-${CI_PIPELINE_ID}"
      --web-identity-token $CI_JOB_JWT_V2
      --duration-seconds 3600
      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
      --output text))
    - export AWS_ACCESS_KEY_ID="${STS[0]}"
    - export AWS_SECRET_ACCESS_KEY="${STS[1]}"
    - export AWS_SESSION_TOKEN="${STS[2]}"
    - aws sts get-caller-identity
```

`CI_JOB_JWT_V2`: Predefined variable.
`ROLE_ARN`: The role ARN created by the module


### References
[Connect to cloud services](https://docs.gitlab.com/ee/ci/cloud_services/index.html)
[Configure OpenID Connect in AWS to retrieve temporary credentials](https://docs.gitlab.com/ee/ci/cloud_services/aws/index.html)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.43.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.20.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.asume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gitlab_organization"></a> [gitlab\_organization](#input\_gitlab\_organization) | The Gitlab organization/account to allow access to AWS | `string` | n/a | yes |
| <a name="input_gitlab_repositories"></a> [gitlab\_repositories](#input\_gitlab\_repositories) | The Gitlab repositories inside the organization/account you want to allow access to AWS, default all repositories inside the organization | `list(string)` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_gitlab_url"></a> [gitlab\_url](#input\_gitlab\_url) | The URL of the Gitlab provider | `string` | `"https://gitlab.com"` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | The ARNs of the managed policies to attach to the role | `list(string)` | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the IAM role | `string` | `"GitlabCIRole"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_assume_role_policy"></a> [assume\_role\_policy](#output\_assume\_role\_policy) | Assume role policy, this value can be used to create another role outside this module |
| <a name="output_oidc"></a> [oidc](#output\_oidc) | Gitlab openid connect provider |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | Arn of the IAM role allowed to authenticate to AWS from Gitlab CI |

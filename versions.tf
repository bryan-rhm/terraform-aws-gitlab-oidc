terraform {
  required_version = ">= 0.13.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.43.0"
    }
    tls = {
        source  = "hashicorp/tls"
        version = ">= 3.4.0"
    }
  }
}

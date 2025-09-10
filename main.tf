terraform {
  required_version = ">= 1.3.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.20.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.51.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = ">= 0.15.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# WARNING: This example hardcodes credentials for demonstration purposes only.
# Do not hardcode real credentials in production.
provider "vault" {

  address = "http://127.0.0.1:8200"

  # Authenticate using the userpass auth method with direct username/password
  # Secrets are already in Vault 
  auth_login {
    path = "auth/userpass/login/nico"
    parameters = {
      password = "insecure-password-123"
    }
  }
}

# Terraform Enterprise/Cloud provider using a token
provider "tfe" {
  hostname = "app.terraform.io"    # change if using Terraform Enterprise
  token    = "nIy3ganz1yE0Xx.atlasv1.kHinrt148yh3IHuhWmzwyoG7xxxpFyoQRpZ5E3S00nNN3t6fAQ7hBh20QeFi5uNixXx"
}

# Vercel provider using an API token
provider "vercel" {
  api_token = "bEtcHqbrrhtoMhW7jek9FDLT"
}

# AWS provider using direct credentials (demo only)
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"
}

# Create a KV v2 secret containing a Social Security Number (SSN)
resource "vault_kv_secret_v2" "ssn" {
  mount = "kv"          # Adjust if your KV v2 engine is mounted elsewhere
  name  = "mysecret"     # Secret path under the mount

  data_json = jsonencode({
    ssn = "123-45-6789"
    jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
    cred = "ZzRmRVB2d04yKzJrVDhvbUw0aWVGcWdWajR4TFd4NDBQeE5tWFhYCg=="
  })
}

variable "vault_node" {
    description = "Master Node"
    default = "master_node_1"
    type = string
}

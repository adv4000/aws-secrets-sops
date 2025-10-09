terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
    }
  }
}

ephemeral "sops_file" "secrets" {
  source_file = "secrets.yml"
}

#---Deploy Secret file to AWS Secrets Manager-------
resource "aws_secretsmanager_secret" "my_secret" {
  name        = "my-secrets1"
  description = "My Secrets"
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id                = aws_secretsmanager_secret.my_secret.id
  secret_string_wo         = jsonencode(yamldecode(ephemeral.sops_file.secrets.raw))
  secret_string_wo_version = 1
}

#---Deploy Secret file to AWS SSM Parameter Store-------
resource "aws_ssm_parameter" "my_secret" {
  name             = "my-secrets"
  type             = "SecureString"
  value_wo         = jsonencode(yamldecode(ephemeral.sops_file.secrets.raw))
  value_wo_version = 1
}

variable "tags" {
  description = "Tags to apply to Resources"
  default = {
    Owner   = "Denis Astahov"
    Company = "ADV-IT"
  }
}

variable "name" {
  description = "Name to use for Resources"
  default     = "secrets-demo"
}

variable "smg_secret_arn" {
  description = "The ARN of the AWS Secrets Manager secret"
  type        = string
  default     = "arn:aws:secretsmanager:ca-central-1:827611452653:secret:my-secrets1"
}

variable "ssm_secret_arn" {
  description = "The ARN of the AWS Parameter Store"
  type        = string
  default     = "arn:aws:ssm:ca-central-1:827611452653:parameter/my-secrets"
}

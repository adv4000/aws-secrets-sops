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

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ca-central-1"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
  default     = "demo-app"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "demo-ecs-cluster"
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
  default     = "flask-ecs-service"
}

variable "container_name" {
  description = "The name of the container in the ECS task definition"
  type        = string
  default     = "demo"
}

variable "desired_count" {
  description = "The desired number of ECS service tasks"
  type        = number
  default     = 1
}

variable "image_url" {
  description = "The URL of the image to use for the container"
  type        = string
  default     = "public.ecr.aws/adv-it/ecs-secrets:latest"
}


resource "aws_lambda_function" "this" {
  function_name    = var.name
  description      = "Created by Terraform"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.13"
  handler          = "lambda_function.lambda_handler"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  tags             = var.tags

  environment {
    variables = {
      SECRET_FROM_PARAMETER_STORE = var.ssm_secret_arn
      SECRET_FROM_SECRETS_MANAGER = var.smg_secret_arn
      ENV_VAR1                    = "AWS Community Day 2025"
      ENV_VAR2                    = "Central Asia - Kazakhstan"
    }
  }
}


resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}


data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "lambda_function.zip"
  source {
    filename = "lambda_function.py"
    content  = file("${path.module}/lambda_function.py")
  }
}

#--------------- Lambda IAM Permissions

resource "aws_iam_role" "lambda" {
  name               = "${var.name}-iam-role"
  tags               = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.name}-iam-role-policy"
  tags   = var.tags
  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid"   : "LoggingPermissions",
              "Effect": "Allow",
              "Action": [
                  "logs:CreateLogGroup",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents",
                  "ssm:GetParameter",
                  "secretsmanager:GetSecretValue",
                  "kms:Decrypt"
              ],
              "Resource": ["*"]
          }
      ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda" {
  name       = "${var.name}-iam-policy-attachment"
  roles      = [aws_iam_role.lambda.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}

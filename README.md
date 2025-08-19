# Store Secrets in GIT using SOPS, Deploy and use in AWS!


SOPS Encrypt/Decrypt Secret YAML file using AWS KMS Key:
```
export SOPS_KMS_ARN="arn:aws:kms:ca-west-1:827611452653:key/064f616f-1a84-4768-a93f"
sops --encrypt -i secrets-sops.yml 
sops --decrypt -i secrets-sops.yml
```

DEMOS:
1. Deploy Secrets to SSM Parameter Store and AWS Secrets Manager
2. Use Secrets in AWS Lambda Function using boto3
3. Use Secrets in AWS ECS using Environment Variables/Secrets Reference
4. Use Secrets in AWS EKS using CSI with Pod Identity


Copyleft &copy; by Denis Astahov 2025.
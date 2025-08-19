data "aws_eks_cluster" "this" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    token                  = data.aws_eks_cluster_auth.this.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  token                  = data.aws_eks_cluster_auth.this.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
}


# Install Secret CSI Driver and ASCP
resource "helm_release" "aws_secrets_csi_driver_and_ascp" {
  name       = "csi-secrets-store"
  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"
  version    = "2.0.0"
}

# Install PodIdentity Agent
resource "aws_eks_addon" "secrets" {
  cluster_name = var.eks_cluster_name
  addon_name   = "eks-pod-identity-agent"
}

# Create IAM Policy to Access Required Secrets
resource "aws_iam_policy" "access_secrets" {
  name = "${var.eks_cluster_name}-secrets-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "ssm:GetParameters"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create IAM Role to Access Required Secrets
resource "aws_iam_role" "secrets" {
  name = "${var.eks_cluster_name}-secrets-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "pods.eks.amazonaws.com" },
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.secrets.name
  policy_arn = aws_iam_policy.access_secrets.arn
}

# Create Pod Identity Association
resource "aws_eks_pod_identity_association" "secrets" {
  cluster_name    = var.eks_cluster_name
  namespace       = "demo"
  service_account = "demo-secrets-eks-serviceaccount"
  role_arn        = aws_iam_role.secrets.arn
  depends_on      = [aws_eks_addon.secrets]
}

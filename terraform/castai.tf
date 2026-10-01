data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

resource "castai_eks_cluster" "castai_cluster" {
  account_id = data.aws_caller_identity.current.account_id
  region     = var.aws_region
  name       = var.cluster_name
}

module "castai_eks_role" {
  source = "castai/eks-role/aws"
  version = "~> 0.1"

  aws_account_id     = data.aws_caller_identity.current.account_id
  aws_cluster_region = var.aws_region
  aws_cluster_name   = var.cluster_name
  vpc_id             = module.vpc.vpc_id
}

resource "helm_release" "castai_agent" {
  name             = "castai-agent"
  repository       = "https://castai.github.io/helm-charts"
  chart            = "castai-cluster-controller"
  namespace        = "castai-agent"
  create_namespace = true

  set {
    name  = "apiKey"
    value = var.castai_api_token
  }
  set {
    name  = "clusterId"
    value = castai_eks_cluster.castai_cluster.id
  }
  
  depends_on = [module.eks, castai_eks_cluster.castai_cluster]
}

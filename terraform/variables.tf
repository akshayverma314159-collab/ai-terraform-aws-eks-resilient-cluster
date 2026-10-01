variable "aws_region" {
  description = "AWS region for the EKS cluster"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Name of the autonomous EKS cluster"
  type        = string
  default     = "sre-autonomous-cluster"
}

variable "castai_api_token" {
  description = "API token for Cast AI integration"
  type        = string
  sensitive   = true
}

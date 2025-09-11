variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster-fediuk"
}

variable "ecr_repo_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "lesson7-django"
}

variable "vpc_id" {
  default = "vpc-fediuk"
}

variable "instance_type" {
  description = "EC2 instance type for the worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "lesson-5-ecr"
}

variable "db_name" {
    description = "Name of the EKS cluster"
    type        = string
    default     = "lesson7db" 
}

variable "db_user" {
    description = "Name of the EKS cluster"
    type        = string
    default = "lesson7user"
}

variable "db_password" { 
    description = "Name of the EKS cluster"
    type        = string
    default = "admin123" 
    }

variable "github_pat" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_user" {
  description = "GitHub username"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repository name"
  type        = string
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "syvora-devops-eks"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "desired_size" {
  description = "Desired size of node group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Min size of node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Max size of node group"
  type        = number
  default     = 4
}

variable "instance_types" {
  description = "Instance types for nodes"
  type        = list(string)
  default     = ["t3.medium"]
}
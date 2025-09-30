output "cluster_name" {
  value = module.eks.cluster_name
}

output "kubeconfig" {
  description = "Command to update kubeconfig for kubectl"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region}"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
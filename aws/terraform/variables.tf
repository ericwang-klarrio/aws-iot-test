variable "region" {
  default = "eu-central-1"
}


variable "cluster_name" {
  description = "The name of the cluster."
  type        = "string"
  default     = "eks-cluster"
}

variable "worker_instance_type" {
  description = "The type of the cluster workers."
  type        = "string"
  default     = "t3.large"
}

variable "worker_instance_number" {
  description = "The number of the cluster workers."
  type        = "string"
  default     = "3"
}

variable "aws_account_id" {
  description = "AWS account id to add to the aws-auth configmap."
  type        = "string"
}

variable "eks_admin_accounts" {
  description = "The list of admin accounts for the eks cluster."
  type        = "list"
  default     = []
}

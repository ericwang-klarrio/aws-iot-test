variable "region" {
  default = "ap-southeast-2"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = "list"

  default = [
    "126208120899",
  ]
}

variable "map_accounts_count" {
  description = "The count of accounts in the map_accounts list."
  type        = "string"
  default     = 1
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type        = "list"

  default = [
    {
      role_arn = "arn:aws:iam::126208120899:role/eks-full-admin"
      username = "eks-full-admin"
      group    = "system:masters"
    },
  ]
}

variable "map_roles_count" {
  description = "The count of roles in the map_roles list."
  type        = "string"
  default     = 1
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  default = [
    {
      user_arn = "arn:aws:iam::126208120899:user/eric.wang"
      username = "eric.wang"
      group    = "system:masters"
    },
    {
      user_arn = "arn:aws:iam::126208120899:user/ammar.ahmed"
      username = "ammar.ahmed"
      group    = "system:masters"
    },
    {
      user_arn = "arn:aws:iam::126208120899:user/vincent.quigley"
      username = "vincent.quigley"
      group    = "system:masters"
    },
  ]
}

variable "map_users_count" {
  description = "The count of roles in the map_users list."
  type        = "string"
  default     = 3
}
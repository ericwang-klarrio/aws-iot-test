terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.11"
  region  = "${var.region}"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

data "aws_availability_zones" "available" {
}

locals {
  cluster_name = "${var.cluster_name}"

  map_accounts = ["${var.aws_account_id}"]

  map_roles = [
    {
      role_arn = "arn:aws:iam::${var.aws_account_id}:role/eks-full-admin"
      username = "eks-full-admin"
      group    = "system:masters"
    },
  ]

   map_users = [
    for user in "${var.eks_admin_accounts}":
    {
      user_arn = "${format("arn:aws:iam::${var.aws_account_id}:user/%s", user)}"
      username = "${format("%s", user)}"
      group    = "system:masters"
    }
   ]
}


resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name               = "${local.cluster_name}-vpc"
  cidr               = "10.0.0.0/16"
  azs                = "${data.aws_availability_zones.available.names}"
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "true"
  }
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = "${local.cluster_name}"
  subnets      = "${module.vpc.private_subnets}"

  tags = {
  }

  vpc_id = "${module.vpc.vpc_id}"

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "${var.worker_instance_type}"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = "${var.worker_instance_number}"
      additional_security_group_ids = ["${aws_security_group.worker_group_mgmt_one.id}"]
    },
  ]

  worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
  map_roles                            = "${local.map_roles}"
  map_users                            = "${local.map_users}"
  map_accounts                         = "${local.map_accounts}"
}

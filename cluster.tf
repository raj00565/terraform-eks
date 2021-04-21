locals {
  cluster_name = "eks-cluster"
}

module "vpc" {
#  source = "git::ssh://git@github.com/reactiveops/terraform-vpc.git?ref=v5.0.1"
   source = "modules/terraform-aws-eks"
  aws_region = "ap-south-1"
  az_count   = 3
  aws_azs    = "ap-south-1a, ap-south-1b, ap-south-1c"

  global_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}

module "eks" {
#  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v12.1.0"
   source       = modules/modules/terraform-vpc
  cluster_name = local.cluster_name
  vpc_id       = module.vpc.aws_vpc_id
  subnets      = module.vpc.aws_subnet_private_prod_ids

  node_groups = {
    eks_nodes = {
      desired_capacity = 3
      max_capacity     = 3
      min_capaicty     = 3

      instance_type = "t3.medium"
    }
  }

  manage_aws_auth = false
}

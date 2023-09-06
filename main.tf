module "vpc" {
 source     = "./modules/terraform-aws-vpc"
 namespace  = var.namespace
 stage      = var.stage
 name       = var.vpc_name
 cidr_block = var.cidr_block
 enable_dns_hostnames = var.enable_dns_hostnames
 enable_dns_support = var.enable_dns_support
 enable_default_security_group_with_custom_rules = var.enable_default_security_group_with_custom_rules
  tags = {
   Environment   = "prod"
   Resource_type = "vpc"
   Terraform     = "true"
  }
}

module "dynamic_subnets" {
 source             = "./modules/terraform-aws-dynamic-subnets"
 namespace          = var.namespace
 stage              = var.stage
 name               = var.vpc_name
 availability_zones = var.availability_zones
 vpc_id             = module.vpc.vpc_id
 igw_id             = module.vpc.igw_id
 nat_gateways_count = var.nat_gateways_count
 cidr_block         = var.cidr_block
  tags = {
   Environment   = "prod"
   Resource_type = "dynamic_subnets"
   Terraform     = "true"
  }
}


module "ecr" {
 source = "./modules/terraform-aws-ecr"
 enabled   = var.enable_ecr
 namespace = var.namespace
 stage     = var.stage
 name      = var.ecr_name
 enable_lifecycle_policy = var.enable_lifecycle_policy
}

module "eks_cluster_label" {
 source     = "./modules/terraform-null-label"
 namespace  = var.namespace
 name       = var.eks_cluster_name
 stage      = var.stage
 delimiter  = "-"
 attributes = ["cluster"]
}

module "eks_cluster" {
 source                = "./modules/terraform-aws-eks-cluster"
 namespace             = var.namespace
 stage                 = var.stage
 name                  = var.eks_cluster_name
 region                = var.region
 vpc_id                = module.vpc.vpc_id
 subnet_ids            = module.dynamic_subnets.public_subnet_ids
 kubernetes_version    = var.kubernetes_version
 oidc_provider_enabled = var.oidc_provider_enabled
 write_kubeconfig      = var.write_kubeconfig
 workers_role_arns     = [module.eks_node_group.eks_node_group_role_arn]
 workers_security_group_ids = []
 tags = {
   Environment   = "prod"
   Resource_type = "eks_cluster"
   Terraform     = "true"
 }
}

module "eks_node_group" {
 source                = "./modules/terraform-aws-eks-node-group"
 cluster_name              = data.null_data_source.wait_for_cluster_and_kubernetes_configmap.outputs["cluster_name"]
 namespace                 = var.namespace
 stage                     = var.stage
 name                      = var.eks_cluster_name
 subnet_ids                = module.dynamic_subnets.private_subnet_ids
 instance_types            = var.eks_nodegroup_instance_type
 # capacity_type             = "SPOT"
 capacity_type             = "ON_DEMAND"
 desired_size              = var.desired_size
 min_size                  = var.min_size
 max_size                  = var.max_size
 disk_size                 = var.disk_size
 kubernetes_version        = var.kubernetes_version
 cluster_autoscaler_enabled = var.cluster_autoscaler_enabled
 resources_to_tag         = var.resources_to_tag
 existing_workers_role_policy_arns = var.existing_workers_role_policy_arns
 worker_role_autoscale_iam_enabled = var.worker_role_autoscale_iam_enabled
 node_role_policy_arns     = ["arn:aws:iam::aws:policy/SecretsManagerReadWrite"]
 tags = {
   Environment   = "prod"
   Resource_type = "eks-nodegroup"
   Terraform     = "true"
 }
}


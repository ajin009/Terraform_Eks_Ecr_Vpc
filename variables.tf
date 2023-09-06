variable "namespace" {
  default = ""
  description = "The app/organization name given to create lable for the resources from label module "
}

variable "vpc_name" {
  default = "new-vpc"
}

variable "stage" {
  default = ""
  description = "The environment prefix name given to create lable for the resources from label module "
}

variable "cidr_block" {
  default = "172.32.0.0/16"
  description = "CIDR block for creating the VPC"
}

variable "enable_dns_hostnames" {
  default = true
  description = "This variable is to enable/disable dns hostnames in VPC"
}

variable "enable_dns_support" {
  default = true
  description = "This variable is to enable/disable dns support in VPC"
}

variable "enable_default_security_group_with_custom_rules" {
  default = true
  description = "This variable is to enable the default security with custom rules in the VPC"
}

variable "availability_zones" {
  default = ["ap-south-1a","ap-south-1b", "ap-south-1c"]
  description = "This are the availability zones that we are creating the subnets and our aws resources are running"
}

variable "nat_gateways_count" {
  default = 1
  description = "This variable is to restrict the creation of NAT gateways and override the default behaviour of VPC module which will create NAT gateways as per the AZ count"
}

variable "enable_ecr" {
  default = true
  description = "This variable will decide whether the elastic container registries are created or not for the environment"
}

variable "ecr_name" {
  default = "my-new-ecr"
  description = "ECR prefix name given to create lable for the resources from label module "
}

variable "enable_lifecycle_policy" {
  type        = bool
  description = "Set to false to prevent the module from adding any lifecycle policies to any repositories"
  default     = true
}

variable "kubernetes_version" {
  default ="1.25"
  description = "Kubernetes version. Defaults to EKS Cluster Kubernetes version. Terraform will only perform drift detection if a configuration value is provided"
}

variable "eks_cluster_name" {
  default = "my-new-cluster"
  description = "EKS prefix name given to create lable for the resources from label module "
}

variable "oidc_provider_enabled" {
  default = true
  description = "Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html"
}

variable "write_kubeconfig" {
  default = true
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`."
}

variable "eks_nodegroup_instance_type" {
  default = ["t2.medium"]
  description = <<-EOT
    Single instance type to use for this node group, passed as a list. Defaults to ["t2.medium"].
    It is a list because Launch Templates take a list, and it is a single type because EKS only supports a single type per node group.
    EOT
}

variable "desired_size" {
  default = 2
  description = "Initial desired number of worker nodes (external changes ignored)"
}

variable "min_size" {
  default = 2
  description = "Minimum number of worker nodes"
}

variable "max_size" {
  default = 2
  description = "Maximum number of worker nodes"
}

variable "disk_size" {
  default = 20
  description = <<-EOT
    Disk size in GiB for worker nodes. Defaults to 20. Ignored it `launch_template_id` is supplied.
    Terraform will only perform drift detection if a configuration value is provided.
    EOT
}

variable "cluster_autoscaler_enabled" {
  default = true
  description = "Set true to label the node group so that the [Kubernetes Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#auto-discovery-setup) will discover and autoscale it"
}

variable "existing_workers_role_policy_arns" {
  default = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess", "arn:aws:iam::aws:policy/SecretsManagerReadWrite"]
  description = "List of existing policy ARNs that will be attached to the workers default role on creation"
}

variable "worker_role_autoscale_iam_enabled" {
  default = true
  description = <<-EOT
    If true, the worker IAM role will be authorized to perform autoscaling operations. Not recommended.
    Use [EKS IAM role for cluster autoscaler service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) instead.
    EOT
}

variable "resources_to_tag" {
  default = ["instance","volume"]
  description = "List of auto-launched resource types to tag. Valid types are \"instance\", \"volume\", \"elastic-gpu\", \"spot-instances-request\"."
}
variable "region" {
  default = "ap-south-1"
  description = "AWS Region"
}

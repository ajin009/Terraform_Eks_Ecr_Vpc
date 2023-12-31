resource "local_file" "kubeconfig" {
  count                = var.write_kubeconfig && local.enabled ? 1 : 0
  content              = local.kubeconfig
  filename             = substr(var.config_output_path, -1, 1) == "/" ? "${var.config_output_path}kubeconfig_${aws_eks_cluster.default[0].name}" : var.config_output_path
  file_permission      = "0644"
  directory_permission = "0755"
}

locals {
kubeconfig_name = var.kubeconfig_name == "" ? aws_eks_cluster.default[0].name : var.kubeconfig_name
kubeconfig = local.enabled ? templatefile("${path.module}/templates/kubeconfig.tpl", {
    kubeconfig_name                   = local.kubeconfig_name
    endpoint                          = aws_eks_cluster.default[0].endpoint
    cluster_auth_base64               = aws_eks_cluster.default[0].certificate_authority[0].data
    aws_authenticator_command         = var.kubeconfig_aws_authenticator_command
    aws_authenticator_command_args    = length(var.kubeconfig_aws_authenticator_command_args) > 0 ? var.kubeconfig_aws_authenticator_command_args : ["token", "-i", aws_eks_cluster.default[0].name]
    aws_authenticator_additional_args = var.kubeconfig_aws_authenticator_additional_args
    aws_authenticator_env_variables   = var.kubeconfig_aws_authenticator_env_variables
  }) : ""
}
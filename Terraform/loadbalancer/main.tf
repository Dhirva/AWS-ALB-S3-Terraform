module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.13.0"

  name               = "${var.product}-${local.environment}-alb"
  load_balancer_type = "application"
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  subnets            = data.terraform_remote_state.vpc.outputs.vpc_details.public_subnets
  security_groups    = [module.security_group.security_group_id]
  idle_timeout       = 600
  http_tcp_listeners = local.alb_config.http_tcp_listeners

  https_listener_rules = local.alb_config.https_listener_rules

  https_listeners = local.alb_config.https_listeners

  target_groups = local.alb_config.target_groups

  tags = local.tags

}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.product}-${local.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  tags        = local.tags

  ingress_cidr_blocks      = local.sg_config.ingress_cidr_blocks
  ingress_rules            = local.sg_config.ingress_rules
  ingress_with_cidr_blocks = local.sg_config.ingress_with_cidr_blocks

  egress_with_cidr_blocks = local.sg_config.egress_with_cidr_blocks
}
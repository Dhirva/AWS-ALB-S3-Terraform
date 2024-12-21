# resource "aws_eip" "nat" {
#   count = 1
#   tags  = local.tags
# }

module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  version                       = "3.14.0"
  name                          = "${var.product}-${local.environment}-vpc"
  azs                           = local.env_conf.azs
  cidr                          = local.vpc_conf.vpc_cidr_block
  private_subnets               = local.vpc_conf.private_subnets
  public_subnets                = local.vpc_conf.public_subnets
  private_dedicated_network_acl = true
  private_inbound_acl_rules     = local.private_inbound_acl_rules
  private_outbound_acl_rules    = local.private_outbound_acl_rules
  public_dedicated_network_acl  = true
  public_inbound_acl_rules      = local.public_inbound_acl_rules
  public_outbound_acl_rules     = local.public_outbound_acl_rules
  create_database_subnet_group  = false
  enable_dns_hostnames          = true
  enable_nat_gateway            = false
  single_nat_gateway            = false
  # reuse_nat_ips                 = true
  # external_nat_ip_ids           = aws_eip.nat.*.id
  tags                          = local.tags
}
locals {
  region      = var.regions[terraform.workspace]
  environment = terraform.workspace
  env_conf    = lookup(var.environment, local.environment)
  vpc_conf    = local.env_conf["vpc_conf"]
  tags = {
    Environment        = local.environment
    Use_case           = "vpc"
    ProjectName        = "poc"
    Can_be_deleted     = true
    CreatedByTerraform = true
  }
  private_inbound_acl_rules  = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
  private_outbound_acl_rules = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]

  public_inbound_acl_rules  = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
  public_outbound_acl_rules = [{ "cidr_block" : "0.0.0.0/0", "from_port" : 0, "protocol" : "-1", "rule_action" : "allow", "rule_number" : 100, "to_port" : 0 }]
}
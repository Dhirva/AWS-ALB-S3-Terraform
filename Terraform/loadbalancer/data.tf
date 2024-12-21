data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "terraform-one2N-state"
    key     = "vpc.tfstate"
    region  = "us-east-1"
    profile = "One2N"
  }
  workspace = local.environment
}

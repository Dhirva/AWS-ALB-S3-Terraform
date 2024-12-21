terraform {
  backend "s3" {
    bucket  = "terraform-one2n-state"
    key     = "ec2-alb.tfstate"
    region  = "us-east-1"
    profile = "One2N"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.82.2"
    }
  }
}

provider "aws" {
  region  = local.region
  profile = local.env_conf.profile
} 
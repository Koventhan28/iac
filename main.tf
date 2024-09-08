provider "aws" {
  region = var.location
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

locals {
  cidrblock = "10.124.0.0/16"
  instsize = "t2.micro"
}
module "vpc" {
  source             = "./vpc"
  main_cidr          = local.cidrblock
  public_subnets_sn  = 2
  private_subnets_sn = 3
  max_subnets        = 10
  public_subnets     = [for i in range(2, 255, 2) : cidrsubnet(local.cidrblock, 8, i)]
  private_subnets    = [for i in range(1, 255, 2) : cidrsubnet(local.cidrblock, 8, i)]
}

variable "location" {
  default = "us-east-2"
}
/*
module "ec2" {
  source           = "./ec2"
  instance_type    = "t2.micro"
  number_instances = "2"
  securitygroups   = [module.vpc.securitygroups]
  public_subnets   = flatten([module.vpc.public_subnet_ids])
}
*/
module "asg" {
  source = "./asg"
public_subnets = module.vpc.private_subnet_ids
maxno = 3
minno = 2
instancesize = local.instsize
securitygroups = module.vpc.securitygroups
}
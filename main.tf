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

module "vpc" {
  source          = "./vpc"
  main_cidr       = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "location" {
  default = "us-east-2"
}

module "ec2" {
  source           = "./ec2"
  instance_type    = "t2.micro"
  number_instances = "5"
  securitygroups   = [module.vpc.securitygroups]
  public_subnets   = flatten([module.vpc.public_subnet_ids])
}


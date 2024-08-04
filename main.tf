module "vpc" {
  source   = "./vpc"
  cidr     = "10.0.0.0/16"
  location = "us-east-2"
}

module "ec2" {
  source = "./ec2"
  instance_type = "t2.micro"
  depends_on = [ module.vpc ]
  subnets = element(module.vpc.public_subnet_ids,0)
  securitygroups = [module.vpc.securitygroups]
}
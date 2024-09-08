/*output "ami_id" {
  value = module.ec2.ami_id
}

output "instance_id" {
  value = module.ec2.instance_id
}
*/
output "publicids" {
  value = module.vpc.public_subnet_ids
}

output "privateids" {
  value = module.vpc.private_subnet_ids
}

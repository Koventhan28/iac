resource "aws_instance" "this" {
  count                  = var.number_instances
  subnet_id              = element(var.public_subnets,count.index)
  ami                    = data.aws_ami.specific_ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.securitygroups
}
data "aws_ami" "specific_ami" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  most_recent = true
}
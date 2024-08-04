# Create an EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.specific_ami.id
  instance_type = var.instance_type

  subnet_id     = var.subnets
  vpc_security_group_ids = var.securitygroups
  #security_groups = var.securitygroups
  #user_data = file("${path.module}/test.sh")
  #user_data = file("./test.sh")
  
  tags = {
    Name = "WebServerInstance"
  }
}

data "aws_ami" "specific_ami" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  most_recent = true
}

output "instance" {
  value = aws_instance.web.id
}
output "ami_id" {
  value = data.aws_ami.specific_ami.id
}


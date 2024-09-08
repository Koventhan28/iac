resource "aws_autoscaling_group" "this" {
  name                = "testing"
  max_size            = var.maxno
  min_size            = var.minno
  vpc_zone_identifier = flatten([var.public_subnets])
  #health_check_type   = EC2
  launch_configuration = aws_launch_configuration.this.id

}
data "aws_ami" "specific_ami" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  most_recent = true
}



resource "aws_launch_configuration" "this" {
  name_prefix   = "testing"
  image_id      = data.aws_ami.specific_ami.id
  instance_type = var.instancesize
  lifecycle {
    create_before_destroy = true
  }
}
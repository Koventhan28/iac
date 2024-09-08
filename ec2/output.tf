output "ami_id" {
  value = data.aws_ami.specific_ami.id
}


output "instance_id" {
  value = aws_instance.this.*.id
}
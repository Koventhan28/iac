output "public_subnet_ids" {
    description = "ID of the Public Subnet AZ1"
    value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.private[*].id
}
output "securitygroups" {
  value = aws_security_group.main.id
  }
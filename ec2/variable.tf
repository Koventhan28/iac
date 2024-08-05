variable "instance_type" {
    default = "t2.micro"
  
}

variable "subnets" {
 type = list(string)
}

variable "securitygroups" {
 # type = list(string)
}
/*
variable "ami_id" {
  type = string
}
*/
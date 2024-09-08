
variable "main_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {

  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "public_subnets_sn" {
  type = number
}

variable "private_subnets_sn" {
  type = number
}

variable "max_subnets" {
  type = number
}
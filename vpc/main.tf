

resource "aws_vpc" "this" {
  cidr_block           = var.main_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  count             = length(var.public_subnets)
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "public-subnet-${count.index}"
  }

}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  count             = length(var.private_subnets)
  cidr_block = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_subnet.public]
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}


# Create Private Route Table (with no routes to the Internet)
resource "aws_route_table" "private" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_subnet.private]
  tags = {
    Name = "private-route-table"
  }
}


# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_route_table.public]
}
# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
  depends_on     = [aws_route_table.private]
}

resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_route_table.private]
  tags = {
    Name = "igw"
  }
}


# Create a security group
resource "aws_security_group" "main" {
  vpc_id     = aws_vpc.this.id
  depends_on = [aws_route_table.private]
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


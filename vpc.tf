# Create VPC
resource "aws_vpc" "PythonAPP" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = format("%s-VPC", var.name)
  }
}

# Create Public subnet
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.PythonAPP.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-Public-Subnet-1", var.name)
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.PythonAPP.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-Public-Subnet-2", var.name)
  }
}


# Create Private subnet
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.PythonAPP.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = format("%s-Private-Subnet-1", var.name)
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.PythonAPP.id
  cidr_block              = "192.168.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = format("%s-Private-Subnet-2", var.name)
  }
}


# Create Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.PythonAPP.id

  tags = {
    Name = format("%s-IGW", var.name)
  }
}


# Create Elastic IP
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = format("%s-EIP", var.name)
  }
}

# create NAT gateway 
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = format("%s-NAT", var.name)
  }
}

# create route table association
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.PythonAPP.id

  tags = {
    Name = format("%s-Private-Route-Table", var.name)
  }
}

# create route for the private route table and attatch a nat gateway to it
resource "aws_route" "private-rtb-route" {
  route_table_id         = aws_route_table.private-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.natgw.id
}


# associate private subnets to the private route table
resource "aws_route_table_association" "private-subnets1-assoc" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private-rtb.id
}

resource "aws_route_table_association" "private-subnets2-assoc" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private-rtb.id
}


# create route table for the public subnets
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.PythonAPP.id

  tags = {
    Name = format("%s-Public-Route-Table", var.name)
  }
}

# create route for the public route table and attach the internet gateway
resource "aws_route" "public-rtb-route" {
  route_table_id         = aws_route_table.public-rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# associate all public subnets to the public route table
resource "aws_route_table_association" "public-subnets1-assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "public-subnets2-assoc" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-rtb.id
}
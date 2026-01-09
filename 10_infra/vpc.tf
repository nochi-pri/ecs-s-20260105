# ---------------------------------------------
# VPC
# ---------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "10.0.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = false
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-workspace-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "subnet-public1-a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-subnet-public1-a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "subnet-public1-b" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-subnet-public1-b"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "subnet-private1-a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-subnet-private1-a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}


# ---------------------------------------------
# Route Table
# ---------------------------------------------
resource "aws_route_table" "rtb-public1-a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-rtb-public1-a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "rtb-public1-a" {
  route_table_id = aws_route_table.rtb-public1-a.id
  subnet_id      = aws_subnet.subnet-public1-a.id
}

resource "aws_route_table_association" "rtb-public1-b" {
  route_table_id = aws_route_table.rtb-public1-a.id
  subnet_id      = aws_subnet.subnet-public1-b.id
}

resource "aws_route_table" "rtb-private1-a" {
  vpc_id = aws_vpc.vpc.id

  route = []

  tags = {
    Name    = "${var.project}-${var.environment}-rtb-private1-a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "rtb-private1-a" {
  route_table_id = aws_route_table.rtb-private1-a.id
  subnet_id      = aws_subnet.subnet-private1-a.id
}


# ---------------------------------------------
# Internet Gateway
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "rtb-public1-a-igw" {
  route_table_id         = aws_route_table.rtb-public1-a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

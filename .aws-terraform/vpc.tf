provider "aws" {
  region = var.region
}

resource "aws_vpc" "main_app_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "main-app-vpc"
  }
}

resource "aws_subnet" "public_web_subnet1" {
  vpc_id     = aws_vpc.main_app_vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "ap-northeast-1a"
  
  tags = {
    Name = "public-web-subnet"
  }
}

resource "aws_subnet" "public_web_subnet2" {
  vpc_id     = aws_vpc.main_app_vpc.id
  cidr_block = var.db_subnet_cidr_block
  availability_zone = "ap-northeast-1c"
  
  tags = {
    Name = "public-db-subnet"
  }
}

resource "aws_db_subnet_group" "main_subnet_group" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.public_web_subnet1.id, aws_subnet.public_web_subnet2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_internet_gateway" "main_app_igw" {
  vpc_id = aws_vpc.main_app_vpc.id
  
  tags = {
    Name = "main-app-igw"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main_app_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_app_igw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

resource "aws_route_table_association" "public_web1_rtb_association" {
  subnet_id      = aws_subnet.public_web_subnet1.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_web2_rtb_association" {
  subnet_id      = aws_subnet.public_web_subnet2.id
  route_table_id = aws_route_table.public_rtb.id
}

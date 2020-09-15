terraform {
  required_version = "> 0.12.0"
}

provider "aws" {
  profile                 = var.aws_profile
  shared_credentials_file = "~/.aws/credentials"
  region                  = var.aws_region
}

resource "random_id" "random" {
  byte_length = 4
}

resource "aws_vpc" "default" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_subnet" "default1" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "default2" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "default3" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.1.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true
}

resource "aws_security_group" "default" {
  name        = "${var.aws_key_pair_name}-${random_id.random.hex}"
  description = "${var.aws_key_pair_name}-${random_id.random.hex}"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

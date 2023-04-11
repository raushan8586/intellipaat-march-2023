terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.62.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA4LM34PDX2KEIH5EC"
  secret_key = "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"
}

# Create a VPC
resource "aws_vpc" "intellipaat-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "intellipaat-vpc"
  }
}

# Create a Subnet1
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.intellipaat-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet1"
  }
}

# Create a Subnet2
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.intellipaat-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "subnet2"
  }
}

# Create Internet Gateway and attach to VPC
resource "aws_internet_gateway" "igw-intellipaat" {
  vpc_id = aws_vpc.intellipaat-vpc.id

  tags = {
    Name = "igw-intellipaat"
  }
}

# Create Security Group
resource "aws_security_group" "tls-intellipaat" {
  name        = "tls-intellipaat"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.intellipaat-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tls-intellipaat"
  }
}

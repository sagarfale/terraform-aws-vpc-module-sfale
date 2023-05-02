terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {

  region     = "us-east-2"
}

#variable "role_arn" {}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "example-vpc"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "example-igw"
  }
}

# Create a route table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "example-route-table"
  }
}

# Create a route to the internet gateway
resource "aws_route" "example_internet_route" {
  route_table_id = aws_route_table.example_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.example_igw.id
}

# Associate the route table with the VPC's main subnet
resource "aws_route_table_association" "example_association" {
  subnet_id = aws_vpc.example_vpc.main_route_table_association
  route_table_id = aws_route_table.example_route_table.id
}

terraform {
  required_providers {
    aws = {
      version = "4.38.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      App   = "moonfire"
      Owner = "Alfred Gamulo"
    }
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Providing a reference to our default VPC
data "aws_vpc" "default" {
  default = true
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-1b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "us-east-1c"
}

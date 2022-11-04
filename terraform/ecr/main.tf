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

resource "aws_ecr_repository" "moonfire" {
  name                 = "moonfire"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repository_url" {
  value = aws_ecr_repository.moonfire.repository_url
}

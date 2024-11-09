#Provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69.0"
    }
  }
  required_version = ">= 1.9.5"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

#Creates 5 EC2 instances

resource "aws_instance" "production_nodes" {
  count                  = 5
  ami                    = var.ami_id
  instance_type          = var.instance_type_id
  key_name               = "NewAxeCred"
  vpc_security_group_ids = [aws_security_group.some_rule.id]

  tags = {
    name = "production_nodes-${count.index + 1}"
  }

}

#Creates 5 IAM Users

resource "aws_iam_user" "production_dept" {
  for_each   = local.production
  name       = each.key
  depends_on = [aws_instance.production_nodes]
  aws_iam_group_name = [aws_iam_group.DevOps-1.id]
}

locals {
  production = toset(
    [
      "Alan",
      "Barbie",
      "Charlie",
      "David",
    "Enny"]
  )
}
resource "aws_iam_group" "DevOps-1" {
    name = "devOps-Engineers"
    path =  "/users/"
}
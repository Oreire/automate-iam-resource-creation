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
  region     = "eu-west-2"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY

}
#Types of Data Blocks in Terraform
# data "terrafor_remote_state" "name" {
  
# }

# data "external" "name" {
  
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["543428934710"]
# }

#Creates 5 EC2 instances

resource "aws_instance" "production_nodes" {
  count                  = 5
  ami                    = var.ami_id     
  instance_type          = var.instance_type_id
  key_name               = "NewAxeCred"
  vpc_security_group_ids = [aws_security_group.some_rule.id]

  tags = {
    Name = " Production-Node-${count.index + 1} "
  }

}

#Creates 6 IAM Users

resource "aws_iam_user" "production_dept" {
  for_each   = local.production
  name       = each.key
  depends_on = [aws_instance.production_nodes]
}


locals {
  production = toset(
    [
      "Alan",
      "Barbie",
      "Charlie",
      "David",
      "Enny",
    "Flame"]
  )
}
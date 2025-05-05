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


#Creates 5 EC2 instances

resource "aws_instance" "production_nodes" {
  count                  = 5
  ami                    = var.ami_id
  instance_type          = var.instance_type_id
  key_name               = "NewAxeCred-3"
  vpc_security_group_ids = [aws_security_group.some_rule.id]
  iam_instance_profile   = aws_iam_instance_profile.production_instance_profile.name

  tags = {
    Name         = "Production-Node-${count.index + 1}"
    Time-Created = formatdate("MM DD YYYY hh:mm ZZZ", timestamp())
    Department   = "DevOps"
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
    ["Alan", "Barbie", "Charlie", "David", "Enny", "Flame"]
  )
}

# Attach IAM policy to each user

resource "aws_iam_user_policy" "production_policy" {
  for_each = aws_iam_user.production_dept

  name   = "${each.key.name}-policy"
  user   = each.key.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ec2:DescribeInstances"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# IAM User Credentials Automation

resource "aws_iam_access_key" "production_dept" {
  for_each = aws_iam_user.production_dept

  user = each.key.name

  depends_on = [aws_iam_user.production_dept]

  lifecycle {
    create_before_destroy = true
  }
}
# Output access keys and anonymized secret keys

output "iam_access_keys" {
  value = {
    for user, access_key in aws_iam_access_key.production_dept :
    user => {
      access_key_id     = access_key.id
      anonymized_secret = sensitive(substr(access_key.secret, 0, 4) + "****")
    }
  }
  sensitive = true
}
# Create IAM Role

resource "aws_iam_role" "production_role" {
  name               = "ProductionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Department = "DevOps"
  }
}

# Attach IAM Policy to Role

resource "aws_iam_role_policy" "production_role_policy" {
  role   = aws_iam_role.production_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "ec2:DescribeInstances"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach Role to EC2 Instances

resource "aws_iam_instance_profile" "production_instance_profile" {
  name = "ProductionInstanceProfile"
  role = aws_iam_role.production_role.name
}

resource "aws_instance" "production_nodes" {
  count                  = 5
  ami                    = var.ami_id
  instance_type          = var.instance_type_id
  key_name               = "NewAxeCred-3"
  vpc_security_group_ids = [aws_security_group.some_rule.id]
  iam_instance_profile   = aws_iam_instance_profile.production_instance_profile.name

  tags = {
    Name         = " Production-Node-${count.index + 1} "
    Time-Created = formatdate("MM DD YYYY hh:mm ZZZ", timestamp())
    Department   = "DevOps"
  }
}
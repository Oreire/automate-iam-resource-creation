#Variables used in this Terraform Configuration File

variable "ami_id" {}

variable "instance_type_id" {}

variable "region" {}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {

  type      = string
  sensitive = true
}


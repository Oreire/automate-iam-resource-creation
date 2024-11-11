variable "ami_id" {}
variable "instance_type_id" {}
# variable "ingress_port_1" {}
# variable "ingress_port_2" {}
# variable "ingress_port_3" {}
variable "region" {}
variable "AWS_ACCESS_KEY_ID" {
  type = string
  sensitive = true
}
variable "AWS_SECRET_ACCESS_KEY" {
  
  type = string
  sensitive = true
}


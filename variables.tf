# variable "ami_id" {}
variable "instance_type_id" {}
# variable "ingress_port_1" {}
# variable "ingress_port_2" {}
# variable "ingress_port_3" {}
variable "region" {}
variable "access_key" {
  sensitive = true
}
variable "secret_key" {
  sensitive = true
}


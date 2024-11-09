output "public_dns" {
  value = "aws_instance.production[*].public_dns"
}

output "public_ip" {
  value = "aws_instance.production[*].public_ip"
}

output "instance_id" {
  value = "aws_instance.production[*].aws_instance_id"

}


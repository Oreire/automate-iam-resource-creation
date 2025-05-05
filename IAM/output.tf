#Outputs of the EC2 Instances

output "public_dns" {
  value = aws_instance.production_nodes[*].public_dns
}

output "public_ip" {
  value = aws_instance.production_nodes[*].public_ip
}

output "instance_id" {
  value = aws_instance.production_nodes[*].id
}

output "instance_tags" {
  value = aws_instance.production_nodes[*].tags
}

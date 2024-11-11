#Creaste 3 Security Grouos attached to Ec2 Instances

locals {
  inbound_ports  = [80, 443]
  outbound_ports = [443, 8080]
}

resource "aws_security_group" "some_rule" {
  name        = "SSH-HTTP-HTTPS-SG"
  description = "Security Groups for EC2 Instance"
  
  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  
  dynamic "egress" {
    for_each = local.outbound_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
# Network related

#---- [ ELASTIC IP]-------------------------------------------------------------

# Associate the eip to instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.nginx.id
  allocation_id = aws_eip.eip.id
}

# Elastic ip
resource "aws_eip" "eip" {
  vpc      = true

  # store eip
  provisioner "local-exec" {
    command = "echo ELASTIC_IP: ${aws_eip.eip.public_ip} >> ips_output.txt"
  }
}

# -----[ SECURITY GROUP]--------------------------------------------------------
resource "aws_security_group" "allow_tls" {
  name        = "nginx-allow_tls_ssh"
  description = "Allow HTTP(s)/SSH inbound traffic"

  # inbound traffic rule
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.eip.public_ip}/32", "0.0.0.0/0"]
  }

  # inbound traffic rule
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # added the source whitelist with block ${} as needed to add 32 at the end.
    cidr_blocks = ["${aws_eip.eip.public_ip}/32", "0.0.0.0/0"]
  }

  # inbound traffic rule
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # added the source whitelist with block ${} as needed to add 32 at the end.
    cidr_blocks = ["${aws_eip.eip.public_ip}/32", "0.0.0.0/0"]
  }

  # outbound traffic rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls_ssh"
  }
}

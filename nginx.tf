# access public key
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key_vm
}

# ----------- [INSTANCE]--------------------------------------------------------
resource "aws_instance" "nginx" {
  ami = var.ami_iso
  instance_type = var.type_vm
  security_groups = [aws_security_group.allow_tls.name]
  key_name = aws_key_pair.deployer.key_name

  # volume
  root_block_device {
    volume_type = "gp2"
    volume_size = "10"
    delete_on_termination = true
  }

  # tag name in aws.
  tags = {
    Name = "nginx-vm-aws"
  }

  # ------ [provisioner]------------
  # upload to instance the configuration file and bootstrap script
  provisioner "file" {
    source = "config/bootstrap"
    destination = "/tmp/"

    connection {
      type     = "ssh"
      user     = "alpine"
      private_key = file("config/private-key")
      #host     = aws_instance.nginx.public_ip
      host = self.public_ip #better approach
    }
  }
  provisioner "remote-exec" {
    # run the bootstrap script
    inline = [
        "sudo chmod +x /tmp/bootstrap/bootstrap.sh",
        "dos2unix /tmp/bootsrap/bootstrap.sh",
        "sudo sh /tmp/bootstrap/bootstrap.sh"
    ]
   connection {
     type     = "ssh"
     user     = "alpine"
     private_key = file("config/private-key")
     #host     = aws_instance.nginx.public_ip
     host = self.public_ip #better approach
   }
  }

  # save vars into a file.
  provisioner "local-exec" {
    command = "echo PRIVATE_IP: ${aws_instance.nginx.private_ip} >> ips_output.txt"
  }
}

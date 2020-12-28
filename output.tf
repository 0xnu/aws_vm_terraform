# output of terraform plan

#-------- [INSTANCE]--------------
# this will show one attribute.
output "instance-private_ip" {
  value = aws_instance.nginx.private_ip
}
# this will show all resource attributes
output "instance-security_group" {
  value = aws_instance.nginx.security_groups
}

# ------------[ELASTICIP]-----------
output "instance-elastic_ip" {
  value = aws_eip_association.eip_assoc.public_ip
}

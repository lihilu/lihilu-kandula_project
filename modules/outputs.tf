
output "bastion_public_ip" {
  value = aws_instance.bastion_host.*.public_ip
}

output "bastion_private_ip" {
  value = aws_instance.bastion_host.*.private_ip
}

output "security_group_db_id" {
  value = aws_security_group.DB_instnaces_access.id
}

output "my_vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = join(",", concat(aws_subnet.public.*.id))
}

output "private_subnet_id" {
  value = join(",", concat(aws_subnet.private.*.id))
}

output "private_subnet_id_for_ansible" {
  value = aws_subnet.private.*.id[0]
}

output "target_group_arns" {
  value = aws_alb_target_group.consul-server.arn
}

output "alb_security_group" {
  value = aws_security_group.alb_sg.id
}

output "data_ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "alb_dns" {
  value = aws_alb.web-alb.dns_name
}

output "private_subnet_ids_list" {
  value = aws_subnet.private.*.id
}

output "aws_security_group_common_id" {
  value = aws_security_group.common_sg.id
}
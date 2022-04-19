output "public_ip" {
  value = join(",",concat(aws_instance.ec2_web.*.public_ip))
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

  output "target_group_arns" {
    value = aws_lb_target_group.consul-server.arn
  }

  output "lb_security_group" {
    value= aws_security_group.lb_sg.id
  }
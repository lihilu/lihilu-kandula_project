output "public_ip" {
  value = join(",",concat(aws_instance.ec2_web.*.public_ip))
}



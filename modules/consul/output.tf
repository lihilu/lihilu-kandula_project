
output "consul_security_group_id" {
  value = aws_security_group.consul_security_group.id
}

output "aws_iam_instance_profile_name" {
  value = aws_iam_instance_profile.instance_profile.name
}
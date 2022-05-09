output "key_name" {
  value = aws_key_pair.project_instance_key.key_name
}

output "key_local" {
  value = local_file.server_key.filename
}
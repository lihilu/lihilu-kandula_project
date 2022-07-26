
output "elk_server_id" {
  value=join(",", aws_instance.elk.*.id)
}
output "monitor_server_ip" {
  value = join(",", aws_instance.monitor.*.private_ip)
}

output "monitor_server_id"{
    value=join(",", aws_instance.monitor.*.id)
}
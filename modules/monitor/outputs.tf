output "monitor_server_ip" {
  value = join(",", aws_instance.monitor.*.private_ip)
}

output "monitor_server_id"{
    value=join(",", aws_instance.monitor.*.id)
}

output "sg_node_exporter_id" {
  value= aws_security_group.node_exporter_sg.id
}

output "monitor_private_ip" {
  value = aws_instance.monitor[0].private_ip
}

output "monitor_security_group_id" {
  value = aws_security_group.monitor_sg.id
}
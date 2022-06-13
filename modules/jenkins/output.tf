output "jenkins_server_id" {
  value = aws_instance.jenkins_server.id
}

output "jenkins_agent"{
  value = aws_instance.jenkins_agent
}


output "jenkins_server_ip" {
  value = aws_instance.jenkins_server.*.private_ip
}

output "jenkins_agent_ips"{
  value = join(", ",concat(aws_instance.jenkins_agent.*.private_ip))
}

output "jenkins_agent_ip"{
  value = aws_instance.jenkins_agent[0].private_ip
}
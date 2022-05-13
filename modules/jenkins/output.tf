output "jenkins_server_id" {
  value = aws_instance.jenkins_server.id
}

output "jenkins_agent"{
  value = aws_instance.jenkins_agent
}

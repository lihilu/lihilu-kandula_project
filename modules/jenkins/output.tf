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

output "jenkins_agent_role_arn" {
  value = aws_iam_policy.jenkins_agents.arn
}

output "jenkins_agent_arn"{
  value = join(", ",concat(aws_instance.jenkins_agent.*.arn))
}

output "jenkins_instance_agent_role_name" {
  value = aws_iam_instance_profile.jenkins_agents.name
}
output "jenkins_public_ip" {
    value = aws_instance.jenkins.public_ip
}

output "jenkins-agent_private_ip" {
    value = aws_instance.jenkins_agent.private_ip
}

output "jenkins-agent_public_ip" {
    value = aws_instance.jenkins_agent.public_ip
}
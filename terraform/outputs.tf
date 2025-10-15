output "instance_ip" {
  description = "The IP address of the instance"
  value       = aws_instance.application_server.public_ip

}

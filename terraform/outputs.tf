output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.technova.public_ip
}

output "public_dns" {
  value = aws_instance.technova.public_dns
}

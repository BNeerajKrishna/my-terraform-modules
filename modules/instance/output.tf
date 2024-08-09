# Outputs
output "instance_public_ip" {
  value = aws_instance.example_instance.public_ip
}

output "instance_private_ip" {
  value = aws_instance.example_instance.private_ip
}

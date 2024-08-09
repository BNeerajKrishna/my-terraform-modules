# # Outputs
# output "instance_public_ip" {
#   value = aws_instance.example_instance.public_ip
# }

# output "instance_private_ip" {
#   value = aws_instance.example_instance.private_ip
# }

output "app_vpc_id" {
  value = module.app_network.vpc_id
}

output "app_public_subnet_ids" {
  value = module.app_network.public_subnet_ids
}

output "app_private_subnet_ids" {
  value = module.app_network.private_subnet_ids
}

output "load_balancer_url" {
  value = module.load_balancer.load_balancer_url
}

# output "instance_public_ips" {
#   value = module.load_balancer.instance_public_ips
# }

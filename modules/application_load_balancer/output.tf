output "load_balancer_url" {
  value = aws_lb.app_lb.dns_name
}

# output "instance_public_ips" {
#   value = [for instance in data.aws_instances.app_instances.instance : instance.public_ip]
# }
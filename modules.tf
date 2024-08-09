module "app_network" {
  source               = "./modules/network"
  vpc_cidr             = var.app_vpc_cidr
  vpc_name             = var.app_vpc_name
  public_subnet_cidrs  = var.app_public_subnet_cidrs
  private_subnet_cidrs = var.app_private_subnet_cidrs
  availability_zones   = var.app_availability_zones
}

module "mgmt_network" {
  source               = "./modules/network"
  vpc_name             = var.mgmt_vpc_name
  vpc_cidr             = var.mgmt_vpc_cidr
  public_subnet_cidrs  = var.mgmt_public_subnet_cidrs
  private_subnet_cidrs = var.mgmt_private_subnet_cidrs
  availability_zones   = var.mgmt_availability_zones
}

resource "aws_key_pair" "deployer" {
  key_name   = "testkey"
  public_key = file("${path.module}/mykey.pub")
}

module "test_ubuntu_instance" {
  source = "./modules/instance"
  instance_name = var.instance_name
  inbound_ports = var.inbound_ports
  instance_type = var.instance_type
  instance_keypair_name = aws_key_pair.deployer.key_name
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id = module.mgmt_network.public_subnet_ids[0]
  sg_vpc_id = module.mgmt_network.vpc_id
}

# resource "aws_security_group" "ssh_access" {
#   name        = "ssh_access_sg"
#   description = "Security group allowing SSH access"
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "nginx_instance" {
#   availability_zone           = "ap-south-1a"
#   ami                         = data.aws_ami.ubuntu.id 
#   key_name                    = aws_key_pair.deployer.key_name
#   subnet_id                   = "subnet-0d6f05c5f211798cb"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.ssh_access.id]

#   user_data = <<-EOF
#               #!/bin/bash
#               apt-get update
#               apt-get install -y nginx
#               HOSTNAME=$(hostname)
#               echo "<html><body><h1>Welcome to Nginx!</h1><p>Hostname: $HOSTNAME</p></body></html>" > /var/www/html/index.html
#               systemctl start nginx
#               systemctl enable nginx
#               EOF
# }


# resource "aws_ami_from_instance" "nginx_ami" {
#   name               = "nginx_ubuntu"
#   source_instance_id = aws_instance.nginx_instance.id
# }

module "load_balancer" {
  source                = "./modules/application_load_balancer"
  alb_vpc_id            = module.app_network.vpc_id
  alb_subnet_ids        = module.app_network.public_subnet_ids
  target_group_path     = "/"
  target_group_port     = 80
  prefix                = "nginx"
}
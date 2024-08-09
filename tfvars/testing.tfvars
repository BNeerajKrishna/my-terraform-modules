aws_region = "ap-south-1"
app_vpc_cidr = "10.1.0.0/16"
app_vpc_name = "app-vpc"
app_public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
app_private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
app_availability_zones = ["ap-south-1a", "ap-south-1b"]

mgmt_vpc_cidr = "10.2.0.0/16"
mgmt_vpc_name = "mgmt-vpc"
mgmt_public_subnet_cidrs = ["10.2.1.0/24"]
mgmt_private_subnet_cidrs = []
mgmt_availability_zones = ["ap-south-1a", "ap-south-1b"]

instance_name = "test"
instance_type = "t2.micro"
inbound_ports = [22, 80]
associate_public_ip_address = true

variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "app_vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "app_vpc_name" {
  description = "Name tag for the VPC"
  default     = "app-vpc"
}

variable "app_public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "app_private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
}

variable "app_availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "mgmt_vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.2.0.0/16"
}

variable "mgmt_vpc_name" {
  description = "Name tag for the VPC"
  default     = "mgmt-vpc"
}

variable "mgmt_public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.2.1.0/24"]
}

variable "mgmt_private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "mgmt_availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  default     = "test"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "inbound_ports" {
  description = "List of inbound ports to open for the instance"
  type        = list(number)
  default     = [22, 80]
}

variable "associate_public_ip_address" {
  description = "To determine whether EC2 instance should assign a public IP address"
  default = true
}

variable "instance_name" {
  description = "Name of the instance"
  default     = "my-instance"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "inbound_ports" {
  description = "List of inbound ports to open for the instance"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "Subnet ID to deploy instance into"
  type        = string
}

variable "sg_vpc_id" {
  description = "ID of the vpc for security group"
  type = string
  default = "vpc"
}

variable "instance_keypair_name" {
  description = "The name of the EC2 keypair"
  default = "testkey"
  type = string
}
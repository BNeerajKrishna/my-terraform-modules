variable "alb_subnet_ids" {
    type = list(string)
  
}
variable "alb_vpc_id" {
    type = string
  
}

variable "target_group_path" {
  type        = string
  # default     = "/"
}

variable "target_group_port" {
  type        = number
#   default     = 80
}


# variable "subnet_ids" {
#   type        = list(string)
# }

variable "prefix" {
  type        = string
  # default     = "nginx"
}



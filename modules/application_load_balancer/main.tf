data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# data "aws_instances" "app_instances" {
#   filter {
#     name   = "tag:Name"
#     values = ["app-instance"]
#   }

#   filter {
#     name   = "instance-state-name"
#     values = ["running"]
#   }
# }


resource "aws_security_group" "alb_sg" {
  vpc_id = var.alb_vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "launch_template_sg" {
  vpc_id = var.alb_vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  tags = {
    Name = "launch-template-sg"
  }
}

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.alb_subnet_ids
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  idle_timeout       = 60
  enable_http2       = true

  tags = {
    Name = "app-lb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "target-group"
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = var.alb_vpc_id
  health_check {
    interval            = 30
    path                = var.target_group_path
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "target-group"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


resource "aws_launch_template" "app" {
  name_prefix   = "${var.prefix}-app-launch-template"
  image_id       = data.aws_ami.ubuntu.id
  instance_type  = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.launch_template_sg.id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
apt-get update
apt-get install -y nginx
HOSTNAME=$(hostname)
echo "<html><body><h1>Welcome to Nginx!</h1><p>Hostname: $HOSTNAME</p></body></html>" > /var/www/html/index.html
systemctl start nginx
systemctl enable nginx
EOF
)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  min_size                 = 1
  max_size                 = 3
  desired_capacity         = 2
  vpc_zone_identifier      = var.alb_subnet_ids
  health_check_type        = "EC2"
  health_check_grace_period = 300
  tag {
    key                 = "Name"
    value               = "${var.prefix}-app-instance"
    propagate_at_launch = true
  }
  force_delete            = true
  wait_for_capacity_timeout  = "0"
  
  

  # Attach to the ALB Target Group
  
  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }

  target_group_arns = [aws_lb_target_group.target_group.arn]

  lifecycle {
    create_before_destroy = true
  }
}

# ASG Scaling Policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

# resource "aws_autoscaling_attachment" "app_asg_target_group" {
#   autoscaling_group_name = aws_autoscaling_group.app_asg.name
#   lb_target_group_arn    = aws_lb_target_group.target_group.arn
# }

# resource "aws_internet_gateway" "lb_ig" {
#   vpc_id = var.alb_vpc_id
# }

# resource "aws_route_table" "app_route_table" {
#   vpc_id = var.alb_vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.lb_ig.id
#   }
# }

# resource "aws_route_table_association" "app_route_table_association" {
#   subnet_id      = var.alb_subnet_ids[0]
#   route_table_id = aws_route_table.app_route_table.id
# }

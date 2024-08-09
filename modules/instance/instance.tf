data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}



resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for Ubuntu instance"
  vpc_id      =  var.sg_vpc_id

  dynamic "ingress" {
    for_each = var.inbound_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

resource "aws_instance" "example_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type 
  subnet_id              = var.subnet_id  # Choose subnet based on availability zone index
  key_name               = var.instance_keypair_name
  associate_public_ip_address = var.associate_public_ip_address
  security_groups        = [aws_security_group.instance_sg.id]

  tags = {
    Name = var.instance_name
  }
}
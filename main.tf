

provider "aws"{
    region="eu-north-1"
}

resource "aws_launch_configuration" "example" {
  image_id               = "ami-092cce4a19b438926"
  instance_type          = "t3.micro"
  security_groups =  [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
lifecycle {
  create_before_destroy = true
}
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  min_size = 2
  max_size = 10
  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
    }
}

resource "aws_security_group" "instance" {

  name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-example-instance"
}

data "aws_vpc" "default"{
  default =true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
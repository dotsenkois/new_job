provider "aws"{
    region="eu-north-1"
}

resource "aws_instance" "example" {
    ami = "ami-092cce4a19b438926"
    instance_type = "t3.micro"
    vpc_security_group_ids=[aws_security_group.instance.id]
    user_data=<<-EOF
    #!/bin/bash
    echo "Hellow, world" >index.html
    nohup busybox httpd -f -p 8080 &
    EOF
    
    tags = {
        Name ="Terraform-exapmle"
        }
    
}

resource "aws_security_group" "instance"{
    name="terraform-example-instance"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
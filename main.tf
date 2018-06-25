variable "instance_ips" {
    default = {
        "0" = "192.168.1.222"
        "1" = "192.168.1.224"
  }
}
resource "aws_instance" "fabric" {
    count                     = 2
    private_ip                = "${lookup(var.instance_ips, count.index)}"
    ami                       = "ami-68b8e517"
    instance_type             = "t2.micro"
    subnet_id                 = "${aws_subnet.fabric-subnet.id}"
    vpc_security_group_ids    = ["${aws_security_group.allow_http.id}"]
    tags {
        Name = "${var.name}"
    }
}
resource "aws_vpc" "fabric-vpc" {
    cidr_block = "192.168.1.0/16"
}
resource "aws_subnet" "fabric-subnet" {
    vpc_id      = "${aws_vpc.fabric-vpc.id}"
    cidr_block  = "192.168.1.1/24"
    availability_zone = "us-east-1a"
    tags {
        Name="fabric-subnet"
    }
}
resource "aws_security_group" "allow_http" {
    name        = "${var.name} allow_http"
    description = "Allow HTTP traffic"
    vpc_id      = "${aws_vpc.fabric-vpc.id}"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   = 8181
        to_port     = 8181
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

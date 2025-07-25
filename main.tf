provider "aws" {
  region = ap-south-1
}

resource "aws_vpc" "vpc_trail_1" {
  cidr_block = "10.0.0.0/24"
  //enable_dns_support = true
  //enable_dns_hostnames = true

  tags = {
    Name = "vpc_trail_1"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc_trail_1.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = true
  tags = { Name = "public_a" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_trail_1.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_trail_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sg" {
  name = "sg_trail_1"
  description = "Security group for trail-1"
  vpc_id = aws_vpc.vpc_trail_1.id
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"  
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  description = "HTTPS"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    description = "All"
    from_port = 0
    to_port = 0
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu" {
  ami = "ami-0f918f7e67a3323f0"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.public_a.id
  tags = {
     Name = "ubuntu_trail_1"
     }
  user_data = <<-EOF
              #!/bin/bash
              sleep 30
              apt update -y
              apt install -y python3 apache2 openssl
              a2enmod ssl
              a2ensite default-ssl
              systemctl reload apache2
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Hello from Terraform EC2</h1>" > /var/www/html/index.html
              EOF
}


//resource "aws_subnet" "private_a" {
  //vpc_id                  = aws_vpc.vpc_trail_1.id
  //cidr_block              = "10.0.0.0/28"
  //map_public_ip_on_launch = false
  //tags = { Name = "private_a" }
//}

//resource "aws_route_table_association" "private_a" {
  //subnet_id      = aws_subnet.private_a.id
  //route_table_id = aws_route_table.public_rt.id
//}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "vpc_trail_1" {
  cidr_block = "10.0.0.0/24"

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
  name        = "sg_trail_1"
  description = "Security group for trail-1"
  vpc_id      = aws_vpc.vpc_trail_1.id

  #ingress {
   # description = "SSH"
   # from_port   = 22
   # to_port     = 22
   # protocol    = "tcp"
   # cidr_blocks = ["0.0.0.0/0"]
  #}

  #ingress {
   # description = "HTTP"
   # from_port   = 80
   # to_port     = 80
   # protocol    = "tcp"
   # cidr_blocks = ["0.0.0.0/0"]
  #}

  #ingress {
   # description = "HTTPS"
   # from_port   = 443
   # to_port     = 443
   # protocol    = "tcp"
   # cidr_blocks = ["0.0.0.0/0"]
  #}

  #ingress {
   # description = "Tomcat"
   # from_port   = 8080
   # to_port     = 8080
   # protocol    = "tcp"
   # cidr_blocks = ["0.0.0.0/0"]
  #}

dynamic "ingress" {
  for_each = ["80","8080","443","22","1000","8443"]
  content {
    description = "Tomcat"
    from_port   = ingress.value
    to_port     = ingress.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  egress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "ubuntu_trail_1"
  }

  user_data = <<-EOF
              #!/bin/bash
              sleep 30
              apt update -y
              apt install -y openjdk-17-jdk apache2 git wget tar curl
              
              # Set JAVA_HOME permanently
              echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> /etc/profile
              echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile
              
              # Install Maven
              wget https://downloads.apache.org/maven/maven-3/3.8.9/binaries/apache-maven-3.8.9-bin.tar.gz -P /tmp
              tar xzvf /tmp/apache-maven-3.8.9-bin.tar.gz -C /opt
              mv /opt/apache-maven-3.8.9 /opt/maven
              echo "export M2_HOME=/opt/maven" >> /etc/profile
              echo "export PATH=\$M2_HOME/bin:\$PATH" >> /etc/profile
              
              # Git config
              git config --global user.name "balajivb25"
              git config --global user.email "balajiv.b25@gmail.com"

              # Start Apache server
              systemctl enable apache2
              systemctl start apache2
              EOF
}


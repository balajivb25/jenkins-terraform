provider "aws" {
  region = "ap-south-1"
}

variable "ingress_rules" {
  type = map(list(string))
  default = {
    "80"   = ["0.0.0.0/0"]          # HTTP
    "8080" = ["10.0.0.0/16"]        # Internal eg
    "443"  = ["0.0.0.0/0"]          # HTTPS 
    "1000" = ["192.168.1.0/24"]     # Private eg
    "8443" = ["172.16.0.0/12"]      # Restricted, if we want we can add SSH 22 port as well
  }
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

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = "Allow port ${ingress.key}"
      from_port   = tonumber(ingress.key)
      to_port     = tonumber(ingress.key)
      protocol    = "tcp"
      cidr_blocks = ingress.value
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
  user_data = file("user_data.sh")
  tags = {
    Name = "ubuntu_trail_1"
  }
  lifecycle {
    create_before_destroy = true
  }
  # depends_on = [aws_instance.my_server_db, aws_instance.my_server_app] 
  # it will create in sequence like db -> app -> ubuntu(web)
}
#resource "aws_instance" "my_server_app" {
#  ami           = "ami-0f918f7e67a3323f0"
#  instance_type = "t3.micro"
#  vpc_security_group_ids = [aws_security_group.sg.id]
# depends_on = [aws_instance.my_server_db]
#}
#resource "aws_instance" "my_server_db" {
#  ami           = "ami-0f918f7e67a3323f0"
#  instance_type = "t3.micro"
#  vpc_security_group_ids = [aws_security_group.sg.id]
#}

resource "aws_eip" "lb" {
  instance = aws_instance.ubuntu.id
  tags = {
    Name = "ubuntu_elastic_ip"
  }
}




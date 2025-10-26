variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name (create in AWS Console)"
}

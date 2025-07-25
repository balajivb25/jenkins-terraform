output "ec2_public_ip" {
  value = aws_instance.ubuntu.public_ip
}

output "web_url" {
  value = "http://${aws_instance.ubuntu.public_ip}"
}
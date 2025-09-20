output "ec2_public_ip" {
  value = aws_instance.ubuntu.public_ip
}
output "ec2_id" {
  value = aws_instance.my_instance.id
}
output "web_url" {
  value = "http://${aws_instance.ubuntu.public_ip}"

}

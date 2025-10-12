# EC2 instance public IPs
output "ubuntu_public_ips" {
  description = "Public IPs of Ubuntu EC2 instances"
  value       = [for instance in aws_instance.ubuntu : instance.public_ip]
}

# EC2 instance private IPs
output "ubuntu_private_ips" {
  description = "Private IPs of Ubuntu EC2 instances"
  value       = [for instance in aws_instance.ubuntu : instance.private_ip]
}

# EC2 instance IDs
output "ubuntu_instance_ids" {
  description = "IDs of Ubuntu EC2 instances"
  value       = [for instance in aws_instance.ubuntu : instance.id]
}

# ALB DNS name
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.ubuntu_alb.dns_name
}

# ALB ARN
output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.ubuntu_alb.arn
}

# Target Group ARN
output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.ubuntu_tg.arn
}

# Security Group IDs
output "security_group_ids" {
  description = "IDs of Security Groups used"
  value       = [aws_security_group.sg.id, aws_security_group.alb_sg.id]
}

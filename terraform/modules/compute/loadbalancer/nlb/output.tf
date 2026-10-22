output "nlb_arn" {
  description = "The ARN of the Network Load Balancer."
  value       = aws_lb.nlb.arn
}

output "nlb_dns_name" {
  description = "The DNS name of the Network Load Balancer."
  value       = aws_lb.nlb.dns_name
}

output "eip_public_ips" {
  description = "The list of public IPs assigned to the NLB."
  value       = aws_eip.nlb_eip[*].public_ip
}

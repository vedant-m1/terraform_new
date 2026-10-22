output "alb_dns_name" { 
    value = aws_lb.lb.name
}

output "alb_arn"  { 
    value = aws_lb.lb.arn
}

resource "aws_lb" "lb" {
  name               = var.load_balancer_name
  internal           = var.scheme     #true or false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.lb_sg
  subnets            = var.subnet_ids

  enable_deletion_protection = var.deletion_protection    #  true or false

# Standard Access Logs (Requests)
  access_logs {
    bucket  = var.s3_bucket_name
    prefix  = "${var.load_balancer_name}-access-logs"
    enabled = true
  }

  # Connection Logs (TCP/TLS details)
  connection_logs {
    bucket  = var.s3_bucket_name
    prefix  = "${var.load_balancer_name}-connections-logs"
    enabled = true
  }
  tags = {
    Name = "${var.load_balancer_name}"
  }
}



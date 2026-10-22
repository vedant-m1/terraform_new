resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.lb_arn
  port              = var.listner_port
  protocol          = var.listner_protocol
# Certificate logic: Only include these if NOT a network load balancer
  ssl_policy      = var.load_balancer_type == "network" ? null : "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.load_balancer_type == "network" ? null : var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}
# This block handles all extra certificates
resource "aws_lb_listener_certificate" "additional" {
  # Only create these if it's NOT a Network Load Balancer
  for_each = var.load_balancer_type == "network" ? [] : toset(var.additional_certificate_arns)

  listener_arn    = aws_lb_listener.listener.arn
  certificate_arn = each.value
}

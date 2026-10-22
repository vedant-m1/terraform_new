resource "aws_lb_target_group" "lb_tg" {
  name     = var.lb_tg_name
  port     = var.target_port
  protocol = var.target_protocol
  target_type = var.target_type
  vpc_id   = var.vpc_id
  # health_check {
  #   path                = var.health_check_path
  #   #protocol            = var.health_check_protocol
  #   matcher             = "200"
  #   interval            = 30
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   port                = "traffic-port"
  # }
  health_check {
    enabled  = true
    protocol = var.health_check_protocol
    # Only set path, matcher, and timeout for HTTP/HTTPS
    path    = contains(["HTTP", "HTTPS"], var.health_check_protocol) ? var.health_check_path : null
    matcher = contains(["HTTP", "HTTPS"], var.health_check_protocol) ? var.health_check_matcher : null
    timeout = contains(["HTTP", "HTTPS"], var.health_check_protocol) ? var.health_check_timeout : null
    port                = var.health_check_port != null ? var.health_check_port : "traffic-port"
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
  tags = { Name = var.lb_tg_name }
}

resource "aws_lb_target_group_attachment" "instance" {
  # for_each        = toset(var.target_ids)
  for_each = var.target_ids
  target_group_arn= aws_lb_target_group.lb_tg.arn
  target_id       = each.value
  port            = var.target_port
}

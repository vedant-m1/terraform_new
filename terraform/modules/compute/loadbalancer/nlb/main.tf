# Create an Elastic IP for each subnet provided
resource "aws_eip" "nlb_eip" {
  count  = length(var.subnet_ids)
  domain = "vpc"
  tags   = var.tags
}

# Create the Network Load Balancer
resource "aws_lb" "nlb" {
  name                       = var.load_balancer_name
  internal                   = var.internal
  load_balancer_type         = "network"
  enable_deletion_protection = var.deletion_protection
  security_groups = var.nlb_sg
  # Cross-zone load balancing is optional for NLB (default is false)
  enable_cross_zone_load_balancing = true

  # Create a subnet_mapping block for each subnet and its corresponding EIP
  dynamic "subnet_mapping" {
    for_each = var.subnet_ids

    content {
      subnet_id     = subnet_mapping.value
      allocation_id = aws_eip.nlb_eip[subnet_mapping.key].id
    }
  }

  tags = var.tags
}

# Define the security group for NLB.
resource "aws_security_group" "nlb_sg" {
  name        = "${var.env}-Nlb-Sg"
  description = "Security group for nlb"
  vpc_id      = var.vpc_id
  ingress {
    description              = "Allow traffic from office network"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    cidr_blocks              = ["27.107.43.107/32", "115.160.214.115/32", "27.107.44.198/32", "103.8.38.190/32", "27.107.43.106/32", "115.160.214.114/32"]
  }  
  
  tags = {
    Name = "${var.env}-Nlb-Sg"
  }
}

resource "aws_security_group_rule" "nlb_sg_rule" {
  description              = "Allow traffic from NLB to Int ALB"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nlb_sg.id
  source_security_group_id = aws_security_group.int_alb_sg.id
}

# Define the security group for Internal ALB.
resource "aws_security_group" "int_alb_sg" {
  name        = "${var.env}-Int-Alb-Sg"
  description = "Security group for internal alb"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Int-Alb-Sg" 
  }
}
resource "aws_security_group_rule" "int_alb_sg_rule1" {
  description              = "Allow traffic from NLB to Int ALB"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.int_alb_sg.id
  source_security_group_id = aws_security_group.nlb_sg.id
}
resource "aws_security_group_rule" "int_alb_sg_rule2" {
  description              = "Allow traffic from Int ALB to web"
  type                     = "egress"
  from_port                = 1818
  to_port                  = 1818
  protocol                 = "tcp"
  security_group_id        = aws_security_group.int_alb_sg.id
  source_security_group_id = aws_security_group.web_server_sg.id
}


# Define the security group for web servers.
resource "aws_security_group" "web_server_sg" {
  name        = "${var.env}-Web-Sg"
  description = "Security group for web servers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Web-Sg"
  }
}
resource "aws_security_group_rule" "web_sg_rule" {
  description              = "Allow traffic for SSM, Downloading packages"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_server_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web_sg_rule1" {
  description              = "Allow traffic to efs"
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_server_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
}
resource "aws_security_group_rule" "web_sg_rule2" {
  description              = "Allow traffic from alb"
  type                     = "ingress"
  from_port                = 1818
  to_port                  = 1818
  protocol                 = "tcp"
  security_group_id        = aws_security_group.web_server_sg.id
  source_security_group_id = aws_security_group.int_alb_sg.id
}
# locals {
#   # Define all the ports you want to allow from Int ALB to online/event app server
#   portal_app_ports = [9292, 9191, 9393, 9192]
# }
# resource "aws_security_group_rule" "web_sg_rule3" {
#   for_each = toset([for port in local.portal_app_ports : tostring(port)])
#   description              = "Allow traffic from web to portal"
#   type                     = "egress"
#   from_port                = each.value
#   to_port                  = each.value
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.web_server_sg.id
#   source_security_group_id = aws_security_group.portals_server_sg.id
# }

# locals {
#   # Define all the ports you want to allow from web to appgrp server
#   app_ports = [9090, 9191]
# }
# resource "aws_security_group_rule" "web_sg_rule4" {
#   for_each = toset([for port in local.app_ports : tostring(port)])
#   description              = "Allow traffic from web to app servers"
#   type                     = "egress"
#   from_port                = each.value
#   to_port                  = each.value
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.web_server_sg.id
#   source_security_group_id = aws_security_group.app_sg.id
# }
# resource "aws_security_group_rule" "web_sg_rule5" {
#   description              = "Allow traffic to shorturl"
#   type                     = "egress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.web_server_sg.id
#   source_security_group_id = aws_security_group.shortulr_server_sg.id
# } 


# Define the security group for online APP servers.
resource "aws_security_group" "app_sg" {
  name        = "${var.env}-App-Sg"
  description = "Security group for app"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-App-Sg" 
  }
}
resource "aws_security_group_rule" "app_sg_rule1" {
  description              = "Allow traffic for SSM, Downloading packages"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "app_sg_rule2" {
  description              = "Allow traffic to aurora Mysql db"
  type                     = "egress"
  from_port                = 13306
  to_port                  = 13306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.db_sg.id
}
resource "aws_security_group_rule" "app_sg_rule3" {
  description              = "Allow traffic to redis"
  type                     = "egress"
  from_port                = 6389
  to_port                  = 6389
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.redis_sg.id
}
resource "aws_security_group_rule" "app_sg_rule4" {
  description              = "Allow traffic to kafka"
  type                     = "egress"
  from_port                = 9092
  to_port                  = 9092
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.kafka_sg.id
}
resource "aws_security_group_rule" "app_sg_rule5" {
  description              = "Allow traffic to efs"
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
}
# resource "aws_security_group_rule" "app_sg_rule6" {
#   for_each = toset([for port in local.app_ports : tostring(port)])
#   description              = "Allow traffic from web to app servers"
#   type                     = "ingress"
#   from_port                = each.value
#   to_port                  = each.value
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.app_sg.id
#   source_security_group_id = aws_security_group.web_server_sg.id
# }



# Define the security group for Portals servers.
resource "aws_security_group" "portals_server_sg" {
  name        = "${var.env}-Portals-Sg"
  description = "Security group for portals servers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Portals-Sg"
  }
}
resource "aws_security_group_rule" "portal_sg_rule1" {
  description              = "Allow traffic for SSM, Downloading packages"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.portals_server_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "portal_sg_rule2" {
  description              = "Allow traffic to aurora Mysql db"
  type                     = "egress"
  from_port                = 13306
  to_port                  = 13306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.portals_server_sg.id
  source_security_group_id = aws_security_group.db_sg.id
}
resource "aws_security_group_rule" "portal_sg_rule3" {
  description              = "Allow traffic to redis"
  type                     = "egress"
  from_port                = 6389
  to_port                  = 6389
  protocol                 = "tcp"
  security_group_id        = aws_security_group.portals_server_sg.id
  source_security_group_id = aws_security_group.redis_sg.id
}
resource "aws_security_group_rule" "portal_sg_rule4" {
  description              = "Allow traffic to kafka"
  type                     = "egress"
  from_port                = 9092
  to_port                  = 9094
  protocol                 = "tcp"
  security_group_id        = aws_security_group.portals_server_sg.id
  source_security_group_id = aws_security_group.kafka_sg.id
}
resource "aws_security_group_rule" "portal_sg_rule5" {
  description              = "Allow traffic to efs"
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.portals_server_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
}
# resource "aws_security_group_rule" "portal_sg_rule6" {
#   for_each = toset([for port in local.portal_app_ports : tostring(port)])
#   description              = "Allow traffic from Int ALB to portal"
#   type                     = "ingress"
#   from_port                = each.value
#   to_port                  = each.value
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.portals_server_sg.id
#   source_security_group_id = aws_security_group.web_server_sg.id
# }


# Define the security group for batch servers.
resource "aws_security_group" "batch_server_sg" {
  name        = "${var.env}-Batch-Server-Sg"
  description = "Security group for batch server"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Batch-Server-Sg" 
  }
}
resource "aws_security_group_rule" "batch_server_sg_rule1" {
  description              = "Allow traffic for SSM, Downloading packages"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.batch_server_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "batch_server_sg_rule2" {
  description              = "Allow traffic to aurora Mysql db"
  type                     = "egress"
  from_port                = 13306
  to_port                  = 13306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.batch_server_sg.id
  source_security_group_id = aws_security_group.db_sg.id
}
resource "aws_security_group_rule" "batch_server_sg_rule3" {
  description              = "Allow traffic to redis"
  type                     = "egress"
  from_port                = 6389
  to_port                  = 6389
  protocol                 = "tcp"
  security_group_id        = aws_security_group.batch_server_sg.id
  source_security_group_id = aws_security_group.redis_sg.id
}
resource "aws_security_group_rule" "batch_server_sg_rule4" {
  description              = "Allow traffic to kafka"
  type                     = "egress"
  from_port                = 9092
  to_port                  = 9094
  protocol                 = "tcp"
  security_group_id        = aws_security_group.batch_server_sg.id
  source_security_group_id = aws_security_group.kafka_sg.id
}
resource "aws_security_group_rule" "batch_server_sg_rule5" {
  description              = "Allow traffic to efs"
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.batch_server_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
}

# Define the security group for DB servers.
resource "aws_security_group" "db_sg" {
  name        = "${var.env}-Db-Sg"
  description = "Security group for DB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Db-Sg" 
  }
}

resource "aws_security_group_rule" "db_sg_rule1" {
  # Create a set from your list of IDs to loop over
  # for_each = toset([
  #   aws_security_group.app_sg.id,
  #   aws_security_group.batch_server_sg.id,
  #   aws_security_group.portals_server_sg.id
  # ])
  for_each = {
    "app"     = aws_security_group.app_sg.id
    "batch"   = aws_security_group.batch_server_sg.id
    "portals" = aws_security_group.portals_server_sg.id
  }
  description              = "Allow traffic to Aurora Mysql db"
  type                     = "ingress"
  from_port               = 13306
  to_port                 = 13306
  protocol                = "tcp"
  security_group_id       = aws_security_group.db_sg.id # The SG receiving the rule

  # Use 'each.value' to pick up the ID from the current loop iteration
  source_security_group_id = each.value 
 }

# Define the security group for Redis.
resource "aws_security_group" "redis_sg" {
  name        = "${var.env}-Redis-Sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Redis-Sg" 
  }
}
resource "aws_security_group_rule" "redis_sg_rule1" {
  # Create a set from your list of IDs to loop over
  # for_each = toset([
  #   aws_security_group.app_sg.id,
  #   aws_security_group.batch_server_sg.id,
  #   aws_security_group.portals_server_sg.id
  # ])
  for_each = {
    "app"     = aws_security_group.app_sg.id
    "batch"   = aws_security_group.batch_server_sg.id
    "portals" = aws_security_group.portals_server_sg.id
  }
  description              = "Allow traffic from app servers"
  type                     = "ingress"
  from_port               = 6389
  to_port                 = 6389
  protocol                = "tcp"
  security_group_id       = aws_security_group.redis_sg.id # The SG receiving the rule

  # Use 'each.value' to pick up the ID from the current loop iteration
  source_security_group_id = each.value 
}

# Define the security group for Kafka.
resource "aws_security_group" "kafka_sg" {
  name        = "${var.env}-Kafka-Sg"
  description = "Security group for KAFKA"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Kafka-Sg" 
  }
}
resource "aws_security_group_rule" "kafka_sg_rule1" {
  # Create a set from your list of IDs to loop over
  # for_each = toset([
  #   aws_security_group.app_sg.id,
  #   aws_security_group.batch_server_sg.id,
  #   aws_security_group.portals_server_sg.id
  # ])
  for_each = {
    "app"     = aws_security_group.app_sg.id
    "batch"   = aws_security_group.batch_server_sg.id
    "portals" = aws_security_group.portals_server_sg.id
  }
  description              = "Allow traffic from app servers"
  type                     = "ingress"
  from_port               = 9092
  to_port                 = 9094
  protocol                = "tcp"
  security_group_id       = aws_security_group.kafka_sg.id # The SG receiving the rule

  # Use 'each.value' to pick up the ID from the current loop iteration
  source_security_group_id = each.value 
}



# Define the security group for EFS.
resource "aws_security_group" "efs_sg" {
  name        = "${var.env}-Efs-Sg"
  description = "Security group for EFS"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env}-Efs-Sg" 
  }
}
resource "aws_security_group_rule" "efs_sg_rule1" {
  # Create a set from your list of IDs to loop over
  # for_each = toset([
  #   aws_security_group.app_sg.id,
  #   aws_security_group.batch_server_sg.id,
  #   aws_security_group.portals_server_sg.id,
  #   aws_security_group.web_server_sg.id
  # ])
  for_each = {
    "app"     = aws_security_group.app_sg.id
    "batch"   = aws_security_group.batch_server_sg.id
    "portals" = aws_security_group.portals_server_sg.id
    "web"     = aws_security_group.web_server_sg.id
  }
  description              = "Allow traffic from app servers"
  type                     = "ingress"
  from_port               = 2049
  to_port                 = 2049
  protocol                = "tcp"
  security_group_id       = aws_security_group.efs_sg.id # The SG receiving the rule

  # Use 'each.value' to pick up the ID from the current loop iteration
  source_security_group_id = each.value 
}

# resource "aws_security_group" "siem_sg" {
#   name        = "${var.env}-Siem-Sg"
#   description = "Security group for siem server"
#   vpc_id      = var.vpc_id
#   ingress {
#     description              = "Allow SSH traffic from office network"
#     from_port                = 22
#     to_port                  = 22
#     protocol                 = "tcp"
#     cidr_blocks              = ["27.107.43.107/32", "115.160.214.115/32", "27.107.44.198/32", "103.8.38.190/32", "27.107.43.106/32", "115.160.214.114/32"]
#   }  
  
#   tags = {
#     Name = "${var.env}-Siem-Sg"
#   }
# }
# resource "aws_security_group_rule" "siem_sg_rule1" {
#   description              = "Allow traffic for SSM, Downloading packages"
#   type                     = "egress"
#   from_port                = 443
#   to_port                  = 443
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.siem_sg.id
#   cidr_blocks              = ["0.0.0.0/0"]
# }

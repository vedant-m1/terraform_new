variable "lb_tg_name" {
  type = string
}
variable "lb_target_port" {
  type = number
}
variable "target_protocol" {
  type = string
}
variable "vpc_id" {
  type = string
}
# variable "health_check_path" {
#   type = string
# }
# variable "target_ids" {
#   type = list(string)
# }
variable "target_ids" {
  type = map(string)
}
variable "target_port" {
  type = string
}
variable "target_type" {
  type = string
}
variable "health_check_interval" {
  type = string
}
# variable "health_check_port" {
#   type = string
# }
variable "healthy_threshold" {
  type = string
}
variable "unhealthy_threshold" {
  type = string
}
# variable "health_check_matcher" {
#   type = string
# }
# variable "health_check_timeout" {
#   type = string
# }

# variable "health_check_matcher" {
#   type        = string
#   description = "HTTP response code matcher"
#   default     = null # Do NOT default to "" or "200"
# }

# variable "health_check_path" {
#   type        = string
#   description = "HTTP health check path"
#   default     = null # Do NOT default to "/"
# }

variable "health_check_protocol" {
  type        = string
  description = "Health check protocol (HTTP, HTTPS, TCP, UDP, TLS)"
  default     = "TCP"
}

variable "health_check_path" {
  type        = string
  description = "Path for HTTP/HTTPS health checks"
  default     = null # MUST be null
}

variable "health_check_matcher" {
  type        = string
  description = "HTTP response status code matcher"
  default     = null # MUST be null
}

variable "health_check_timeout" {
  type        = number
  description = "Health check timeout in seconds"
  default     = null # MUST be null for TCP
}
variable "health_check_port" {
  type    = string
  default = "traffic-port"
}

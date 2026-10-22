variable "listner_port" {
  type = number
}
variable "listner_protocol" {
  type = string
}
variable "lb_arn" {
  type = string
}
variable "target_group_arn" {
  type = string
}
variable "certificate_arn" {
  type        = string
  default     = null # Makes the certificate optional
  description = "The ARN of the SSL certificate (Required for ALB HTTPS, skip for NLB TCP)"
}
variable "load_balancer_type" {
  type = string
}
variable "additional_certificate_arns" {
  description = "List of additional ACM ARNs for SNI support"
  type        = list(string)
  default     = []
}

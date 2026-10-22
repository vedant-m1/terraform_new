variable "load_balancer_name" {
  description = "The name for the Network Load Balancer."
  type        = string
}

variable "subnet_ids" {
  description = "A list of public subnet IDs for the NLB."
  type        = list(string)
}

variable "internal" {
  description = "If true, the NLB will be internal. If false, it will be internet-facing."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If true, deletion protection is enabled for the NLB."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "nlb_sg" {
  type = list(string)
}

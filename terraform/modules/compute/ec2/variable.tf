variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_state" {
  description = "Set to true to run the instance, false to stop it."
  type        = string
}
variable "volume_size" {
  type = string
}

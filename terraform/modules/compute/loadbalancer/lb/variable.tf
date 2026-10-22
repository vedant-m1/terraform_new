variable "lb_sg" {
  type = list(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "load_balancer_type" {
  type = string
}
variable "load_balancer_name" {
  type = string
}
variable "scheme" {
  type = string
}
variable "deletion_protection" {
  type = string
}
variable "s3_bucket_name" {
  type = string
}

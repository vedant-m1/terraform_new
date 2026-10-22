resource "tls_private_key" "application" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = var.key_name
  public_key = tls_private_key.application.public_key_openssh
}

resource "local_file" "private_key" {
  content          = tls_private_key.application.private_key_pem
  filename         = "${path.module}/${var.key_name}.ppk"
  file_permission  = "0600"
}

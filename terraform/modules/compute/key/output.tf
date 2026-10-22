output "key_name" {
  value     = aws_key_pair.generated.key_name
  sensitive = true
}


output "tls_private_key" {
  value = tls_private_key.application.private_key_pem
}

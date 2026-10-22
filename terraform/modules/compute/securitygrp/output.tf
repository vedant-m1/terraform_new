output "web_sg_id" {
  value = aws_security_group.web_server_sg.id
}
output "app_sg_id" {
  value = aws_security_group.app_sg.id
}
 output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
output "portals_server_sg_id" {
  value = aws_security_group.portals_server_sg.id
}
output "batch_server_sg_id" {
  value = aws_security_group.batch_server_sg.id
}
output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}
output "efs_sg_id" {
  value = aws_security_group.efs_sg.id
}
output "kafka_sg_id" {
  value = aws_security_group.kafka_sg.id
} 
output "nlb_sg_id" {
  value = aws_security_group.nlb_sg.id
}
output "int_alb_sg_id" {
  value = aws_security_group.int_alb_sg.id
}
# output "siem_server_sg_id" {
#   value = aws_security_group.siem_sg.id
# } 

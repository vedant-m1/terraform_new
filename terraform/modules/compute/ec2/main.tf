resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  iam_instance_profile = "AmazonSSMManagedInstance"
  vpc_security_group_ids = [var.security_group_id]
  #disable_api_termination = true # Enable termination protection
  disable_api_termination = false # Disable termination protection

  # Configuration for the main OS disk
  root_block_device {
    # This ensures the root volume is deleted when the instance is terminated.
    delete_on_termination = true
    encrypted = true
    volume_type = "gp3"
    volume_size = var.volume_size
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_ec2_instance_state" "instance_state" {
  instance_id = aws_instance.ec2_instance.id
  state = var.instance_state     # "running" or "stopped"
  depends_on = [aws_instance.ec2_instance]
} 

resource "aws_instance" "web_app_instance" {
  ami                    = var.custom_ami  // Use your custom AMI
  instance_type         = var.instance_type // Reference the instance_type variable
  vpc_security_group_ids = [aws_security_group.application_sg.id] // Attach the application security group
  subnet_id             = element(aws_subnet.aws_tanuj_public_subnets[*].id, 0) // Assign to the first public subnet
  associate_public_ip_address = true // Assign a public IP address

  key_name = var.key_pair_name // Reference to the key pair for SSH access

  // Root block device configuration
  root_block_device {
    volume_size           = 30 // Ensure this meets the minimum required size for your AMI
    volume_type           = "gp2" // General Purpose SSD (GP2)
    delete_on_termination  = true // Ensure the EBS volume is terminated with the instance
  }

  tags = {
    Name = "Web Application Instance"
  }
}

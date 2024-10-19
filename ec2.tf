resource "aws_instance" "web_app_instance" {
  ami                         = var.custom_ami                                    
  instance_type               = var.instance_type                                     
  vpc_security_group_ids      = [aws_security_group.application_sg.id]                
  subnet_id                   = aws_subnet.aws_tanuj_public_subnets[0].id  
  associate_public_ip_address = true                                                

  key_name = var.key_pair_name 

  root_block_device {
    volume_size           = 30    
    volume_type           = "gp2" 
    delete_on_termination = true  
  }

  tags = {
    Name = "Web Application Instance"
  }
}

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

  depends_on = [aws_db_instance.rds_instance]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y mysql-server

              #!/bin/bash
              echo "DATABASE_HOST=${aws_db_instance.rds_instance.endpoint}" >> /home/csye6225/webapp/.env
              echo "DATABASE_USERNAME=${var.DB_USERNAME}" >> /home/csye6225/webapp/.env
              echo "DATABASE_PASSWORD=${var.DB_PASSWORD             }" >> /home/csye6225/webapp/.env
              echo "DATABASE_NAME=${var.DB_NAME}" >> /home/csye6225/webapp/.env

              cd /home/csye6225/webapp
              npm install 
              sudo systemctl start webapp 
              sudo systemctl enable webapp 
              EOF

  
}



//resource "aws_iam_instance_profile" "ec2_instance_profile" {
//name = "ec2-role-instance-profile"
//role = aws_iam_role.ec2_role.name
//}

//resource "aws_instance" "web_app_instance" {
//ami                         = var.custom_ami
//instance_type               = var.instance_type
//vpc_security_group_ids      = [aws_security_group.application_sg.id]
//subnet_id                   = aws_subnet.aws_tanuj_public_subnets[0].id
//associate_public_ip_address = true

//key_name = var.key_pair_name

//iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name


//root_block_device {
//volume_size           = 30
//volume_type           = "gp2"
//delete_on_termination = true
//}

//depends_on = [aws_db_instance.rds_instance]

//user_data = <<-EOF
#!/bin/bash
//  apt-get update
//apt-get install -y mysql-server

//mkdir -p /home/csye6225/webapp
//echo "DATAB_HOST=${element(split(":", aws_db_instance.rds_instance.endpoint), 0)}" >> /home/csye6225/webapp/.env
//echo "DATAB_USER=${var.DB_USERNAME}" >> /home/csye6225/webapp/.env
//echo "DATAB_PASS=${var.DB_PASSWORD}" >> /home/csye6225/webapp/.env
//echo "DATAB_NAME=${var.DB_NAME}" >> /home/csye6225/webapp/.env
//echo "PORT=${var.port}" >> /home/csye6225/webapp/.env
// echo "AWS_ACCESS_KEY_ID =${var.aws_access_key_id}" >> /home/csye6225/webapp/.env
//echo "AWS_ACCESS_KEY_ID =${var.aws_secret_access_key}" >> /home/csye6225/webapp/.env
//echo "AWS_REGION=${var.region}" >> /home/csye6225/webapp/.env
//echo "S3_BUCKET=${aws_s3_bucket.aws_s3_bucket.bucket}" >> /home/csye6225/webapp/.env





//cd /home/csye6225/webapp
//npm install 

# Start and enable the web application service
//           sudo systemctl daemon-reload
//         sudo systemctl start webapp 
//       sudo systemctl enable webapp 
//     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/cloudwatch-config.json
//   EOF
//}


resource "aws_launch_template" "csye6225_asg" {
  name          = "csye6225_asg"
  image_id      = var.custom_ami
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.application_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
    }
  }

  key_name = var.key_pair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_role_profile.name
  }

  user_data = base64encode(<<-EOF
   #!/bin/bash
              apt-get update
              apt-get install -y mysql-server

              mkdir -p /home/csye6225/webapp
              echo "DATAB_HOST=${element(split(":", aws_db_instance.rds_instance.endpoint), 0)}" >> /home/csye6225/webapp/.env
              echo "DATAB_USER=${var.DB_USERNAME}" >> /home/csye6225/webapp/.env
              echo "DATAB_PASS=${var.DB_PASSWORD}" >> /home/csye6225/webapp/.env
              echo "DATAB_NAME=${var.DB_NAME}" >> /home/csye6225/webapp/.env
              echo "PORT=${var.port}" >> /home/csye6225/webapp/.env
              echo "AWS_ACCESS_KEY_ID =${var.aws_access_key_id}" >> /home/csye6225/webapp/.env
              echo "AWS_ACCESS_KEY_ID =${var.aws_secret_access_key}" >> /home/csye6225/webapp/.env
              echo "AWS_REGION=${var.region}" >> /home/csye6225/webapp/.env
              echo "S3_BUCKET=${aws_s3_bucket.aws_s3_bucket.bucket}" >> /home/csye6225/webapp/.env


              


              cd /home/csye6225/webapp
              npm install 

              # Start and enable the web application service
              sudo systemctl daemon-reload
              sudo systemctl start webapp 
              sudo systemctl enable webapp 
              sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/cloudwatch-config.json
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}


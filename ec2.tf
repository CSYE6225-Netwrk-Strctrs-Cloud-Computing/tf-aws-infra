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
      kms_key_id            = aws_kms_key.ebs_kms_key.arn
    }
  }

  key_name = var.key_pair_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_role_profile.name
  }

  user_data = base64encode(<<-EOF
   #!/bin/bash
              apt-get update
              apt-get install -y awscli jq

              mkdir -p /home/csye6225/webapp
              
              echo "AWS CLI version:" >> /home/csye6225/webapp/user_data_log.txt
              aws --version >> /home/csye6225/webapp/user_data_log.txt

              
              SECRET=$(aws secretsmanager get-secret-value \
              --region ${var.region} \
              --secret-id ${aws_secretsmanager_secret.db_password_secret.name} \
              --query SecretString \
              --output text)

              
              echo "Fetched secret: $SECRET" >> /home/csye6225/webapp/user_data_log.txt

              DB_PASSWORD=$(echo $SECRET | jq -r '.password')

              
              echo "DB Password: $DB_PASSWORD" >> /home/csye6225/webapp/user_data_log.txt

              echo "DATAB_HOST=${element(split(":", aws_db_instance.rds_instance.endpoint), 0)}" >> /home/csye6225/webapp/.env
              echo "DATAB_USER=${var.DB_USERNAME}" >> /home/csye6225/webapp/.env
              echo "DATAB_PASS=$DB_PASSWORD" >> /home/csye6225/webapp/.env
              echo "DATAB_NAME=${var.DB_NAME}" >> /home/csye6225/webapp/.env
              echo "PORT=${var.port}" >> /home/csye6225/webapp/.env
              echo "AWS_ACCESS_KEY_ID =${var.aws_access_key_id}" >> /home/csye6225/webapp/.env
              echo "AWS_ACCESS_KEY_ID =${var.aws_secret_access_key}" >> /home/csye6225/webapp/.env
              echo "AWS_REGION=${var.region}" >> /home/csye6225/webapp/.env
              echo "S3_BUCKET=${aws_s3_bucket.aws_s3_bucket.bucket}" >> /home/csye6225/webapp/.env
              echo "SNS_TOPIC_ARN =${aws_sns_topic.user_creation_topic.arn}" >> /home/csye6225/webapp/.env
              echo "SENDGRID_API_KEY=${var.sendgrid_api_key}" >> /home/csye6225/webapp/.env
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


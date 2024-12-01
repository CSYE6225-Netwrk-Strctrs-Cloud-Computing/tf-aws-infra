resource "aws_db_parameter_group" "rds_parameter_group" {
  name_prefix = "rds-parameter-group"
  family      = "mysql8.0"
  description = "RDS DB parameter group for MySQL 8.0"

  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "innodb_buffer_pool_size"
    value = "268435456"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "csye6225-subnet-group"
  subnet_ids = aws_subnet.aws_tanuj_private_subnets[*].id
  tags = {
    Name = "CSYE6225 RDS Subnet Group"
  }
}

resource "aws_db_instance" "rds_instance" {
  db_name                = var.DB_NAME
  identifier             = var.DB_IDENTIFIER
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  multi_az               = false
  username               = var.DB_USERNAME
  password               = jsondecode(aws_secretsmanager_secret_version.db_password_version.secret_string).password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  publicly_accessible    = false
  parameter_group_name   = aws_db_parameter_group.rds_parameter_group.name
  allocated_storage      = 20
  skip_final_snapshot    = true
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds_kms_key.arn

  tags = {
    Name = "CSYE6225 RDS Instance"
  }
}

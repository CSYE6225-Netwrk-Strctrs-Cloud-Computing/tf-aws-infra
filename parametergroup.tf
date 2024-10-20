resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "csye6225-parameter-group"
  family = "mysql8.0"  
  description = "Parameter group for CSYE6225 database"

  tags = {
    Name = "CSYE6225 DB Parameter Group"
  }
}

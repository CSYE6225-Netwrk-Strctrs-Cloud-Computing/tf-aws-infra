resource "aws_vpc" "vpc_tanuj" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-tanuj-${var.region}"
  }
}

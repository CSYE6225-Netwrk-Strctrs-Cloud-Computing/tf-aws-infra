resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.vpc_tanuj.id
  tags = {
    Name = "Internet Gateway for tanuj vpc"
  }
}

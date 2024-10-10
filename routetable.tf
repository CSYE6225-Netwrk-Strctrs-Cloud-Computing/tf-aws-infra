resource "aws_route_table" "tanuj_public_route_table" {
  vpc_id = aws_vpc.vpc_tanuj.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway.id
  }

  tags = {
    Name = "RouteTable Public: connecting public subnets to this route table"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_tanuj.id

  tags = {
    Name = "Private Route Table for all private subnets"
  }
}

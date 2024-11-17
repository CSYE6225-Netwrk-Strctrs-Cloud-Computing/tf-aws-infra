
resource "aws_eip" "nat_eip" {
  vpc = true
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.aws_tanuj_public_subnets[*].id, 0)

  tags = {
    Name = "nat-gateway"
  }
}


resource "aws_route" "private_route_to_nat_gateway" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}


resource "aws_route_table_association" "public_subnet_association" {
  count          = var.number_of_public_subnets
  subnet_id      = element(aws_subnet.aws_tanuj_public_subnets[*].id, count.index)
  route_table_id = aws_route_table.tanuj_public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = var.number_of_private_subnets
  subnet_id      = element(aws_subnet.aws_tanuj_private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

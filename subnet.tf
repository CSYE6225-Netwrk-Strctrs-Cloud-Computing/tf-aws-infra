resource "aws_subnet" "aws_tanuj_public_subnets" {
  count = var.number_of_public_subnets
  vpc_id = aws_vpc.vpc_tanuj.id
  cidr_block = cidrsubnet(aws_vpc.vpc_tanuj.cidr_block, 8, count.index)

  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "public-subnet-${count.index}-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "aws_tanuj_private_subnets" {
  count = var.number_of_private_subnets
  vpc_id = aws_vpc.vpc_tanuj.id
  cidr_block = cidrsubnet(aws_vpc.vpc_tanuj.cidr_block, 8, count.index + var.number_of_public_subnets)

  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-subnet-${count.index}-${element(var.availability_zones, count.index)}"
  }
}

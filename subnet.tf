locals {
  public_subnet_cidrs = [for i in range(var.number_of_public_subnets) : cidrsubnet(var.vpc_cidr, 8, i)]

  private_subnet_cidrs = [for i in range(var.number_of_private_subnets) : cidrsubnet(var.vpc_cidr, 8, i + var.number_of_public_subnets)]
}

resource "aws_subnet" "aws_tanuj_public_subnets" {
  count             = var.number_of_public_subnets
  vpc_id            = aws_vpc.vpc_tanuj.id
  cidr_block        = local.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Subnet-Public: Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "aws_tanuj_private_subnets" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.vpc_tanuj.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Subnet-Private: Private Subnet ${count.index + 1}"
  }
}

locals {
  len_private_subnets = length(var.private_subnets)
  len_public_subnets  = length(var.public_subnets)
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge({ "Name" : var.vpcname }, var.tags)
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ "Name" : "${var.vpcname}-gateway" }, var.tags)
}

resource "aws_eip" "this" {
    count = var.enable_nat ? 1: 0
    domain = "vpc"
}

resource "aws_nat_gateway" "this" {
    count = var.enable_nat ? 1:0
    allocation_id = aws_eip.this[0].id
    subnet_id     = element(aws_subnet.public[*].id, count.index)
    tags          = var.tags
    
}


######### Public Subnets #########

resource "aws_subnet" "public" {
  count                   = local.len_public_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags                    = merge({ "Name" : format("${var.vpcname}-public-subnet-%s", count.index + 1) }, var.tags)
}



resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ "Name" : "${var.vpcname}-public-routetable" }, var.tags)
}



resource "aws_route_table_association" "public" {
  count          = local.len_public_subnets
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

}


########### Private Subnets ###########

resource "aws_subnet" "private" {
  count                   = local.len_private_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags                    = merge({ "Name" : format("${var.vpcname}-private-subnet-%s", count.index + 1) }, var.tags)
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = merge({ "Name" : "${var.vpcname}-private-routetable" }, var.tags)
}



resource "aws_route_table_association" "private" {
  count          = local.len_private_subnets
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private" {
    count = var.enable_nat ? 1:0
    route_table_id         = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
}


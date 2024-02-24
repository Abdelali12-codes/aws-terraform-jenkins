output "id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "cidr" {
  description = "Vpc cidr"
  value = aws_vpc.this.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}


output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_routetable_id" {
  description = "private routetable"
  value = aws_route_table.private.id
}
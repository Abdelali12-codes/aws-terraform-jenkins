resource "aws_db_instance" "this" {
  allocated_storage    = 10
  db_name              = "sonarqube"
  identifier = "rds-sonarqube"
  engine               = "postgres"
  engine_version       = "13.12"
  instance_class       = "db.t3.micro"
  username             = var.username
  password             = var.password
  vpc_security_group_ids = [ aws_security_group.this.id ]
  db_subnet_group_name = aws_db_subnet_group.this.name
  skip_final_snapshot  = true
}


resource "aws_security_group" "this" {
  name = "rds-sonarqube-securitygroup"
  vpc_id = var.vpcid
  ingress {
      from_port = 5432
      to_port = 5432
      protocol = "tcp"
      cidr_blocks = [var.cidr]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
    name = "sonarqube-rds-subnet-group"
    subnet_ids = var.subnetids
}
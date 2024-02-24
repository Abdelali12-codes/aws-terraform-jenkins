resource "aws_instance" "this" {
  ami = data.aws_ami.ubuntu.id
  security_groups = [ aws_security_group.this.id ]
  instance_type = var.instancetype
  subnet_id = var.subnetid
  user_data = var.userdata
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    "Name": var.instancename
  }
}


resource "aws_security_group" "this" {
  name = "${var.instancename}-securitygroup"
  vpc_id = var.vpcid
  dynamic "ingress" {
    for_each = flatten([22, var.ingress])
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
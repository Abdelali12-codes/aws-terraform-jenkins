variable "vpcname" {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}


variable "private_subnets" {
  type        = list(string)
  description = "the cidr blocks of private subnets"
}


variable "public_subnets" {
  type        = list(string)
  description = "the cidr blocks of publi subnets"
}


variable "enable_nat" {
  type = bool
  description= "whether to enable nat or not"
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ingress" {
  type =  list(number)
}
variable "instancename" {
  type =  string
}

variable "instancetype" {
   type = string
}

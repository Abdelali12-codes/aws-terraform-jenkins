variable "ingress" {
  type =  list(number)
}
variable "instancename" {
  type =  string
}

variable "instancetype" {
  type = string
}

variable "vpcid" {
   type =  string
}
variable "subnetid" {
   type =  string
}

variable "userdata" {
  type = string
}
module "vpc" {
  source = "./modules/vpc"
  vpcname = var.vpcname
  cidr = var.cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
}


module "jenkins_server" {
   source = "./modules/ec2"
   instancename = var.instancename
   instancetype = var.instancetype
   ingress = var.ingress
   subnetid = element(module.vpc.public_subnets, 0)
   vpcid = module.vpc.id
   userdata = local.jenkins_useradata

   depends_on = [ module.vpc ]
}



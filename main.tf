module "vpc" {
  source = "./modules/vpc"
  vpcname = var.vpcname
  cidr = var.cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
}

module "postgres" {
  source = "./modules/rds"
  vpcid = module.vpc.id
  cidr = module.vpc.cidr
  username = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.this.secret_string)["password"]
  subnetids = module.vpc.private_subnets
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

module "sonaqube" {
  source = "./modules/ec2"
  instancename = "sonarqube_server"
  instancetype = "t3.large"
  ingress = [9000]
  subnetid = element(module.vpc.public_subnets, 0)
  vpcid = module.vpc.id
  userdata = local.sonarqube_userdata
  depends_on = [ module.vpc ]
}



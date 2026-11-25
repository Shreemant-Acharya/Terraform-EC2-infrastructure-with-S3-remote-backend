data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source               = "./modules/vpc"
  name                 = var.env
  vpc_cidr             = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs  = var.public_cidrs
  private_subnet_cidrs = var.private_cidrs
}

module "ec2" {
  source        = "./modules/ec2"
  name          = var.env
  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.public_subnet_ids[0]
  public_key    = file("${path.root}/terraform-ec2-key.pub")
  my_ip_cidr    = var.my_ip_cidr
  instance_type = var.instance_type
}

module "rds" {
  source             = "./modules/rds"
  name               = var.env
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  app_sg_id          = module.ec2.security_group_id
  db_username        = var.db_username
  db_password        = var.db_password
}
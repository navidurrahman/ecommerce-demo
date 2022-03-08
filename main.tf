module "vpc" {
  source = "github.com/tecbrix/terraform-g42-vpc"
}

module "rds" {
  depends_on       = [module.vpc]
  source           = "github.com/tecbrix/terraform-g42-rds"
  subnet_id        = module.vpc.subnetid
  vpc_id           = module.vpc.vpcid
  remote_ip_prefix = module.vpc.vpc_cidr
}
# module "cce" {
#   depends_on              = [module.vpc]
#   source                  = "../terraform-g42-cce"
#   subnet_id               = module.vpc.subnetid
#   vpc_id                  = module.vpc.vpcid
# }

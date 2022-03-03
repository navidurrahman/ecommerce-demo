module "vpc" {
  source   = "github.com/tecbrix/terraform-g42-vpc"
}
module "rds" {
  depends_on              = [module.vpc]
  source                  = "github.com/tecbrix/terraform-g42-rds"
  subnet_id               = module.vpc.subnet_id
  vpc_id                  = module.vpc.vpc_id
}
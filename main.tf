data "g42cloud_availability_zones" "myaz" {}

module "vpc" {
  source = "github.com/tecbrix/terraform-g42-vpc"
}

module "rds" {
  depends_on = [module.vpc]
  source     = "github.com/tecbrix/terraform-g42-rds"
  subnet_id  = module.vpc.subnetid
  vpc_id     = module.vpc.vpcid
  vpc_cidr   = module.vpc.vpc_cidr
}

module "cce" {
  depends_on  = [module.vpc]
  source      = "github.com/tecbrix/terraform-g42-cce"
  subnet_id   = module.vpc.subnetid
  vpc_id      = module.vpc.vpcid
  node_flavor = "s6.large.4"
}

resource "g42cloud_networking_secgroup" "sfssecgroup" {
  name        = "sfs_security_group"
  description = "security group for SFS"
}

resource "g42cloud_networking_secgroup_rule" "sfs_allow_111" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 111
  port_range_max    = 111
  remote_ip_prefix  = module.vpc.vpc_cidr
  security_group_id = g42cloud_networking_secgroup.sfssecgroup.id
}

resource "g42cloud_networking_secgroup_rule" "sfs_allow_445" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 445
  port_range_max    = 445
  remote_ip_prefix  = module.vpc.vpc_cidr
  security_group_id = g42cloud_networking_secgroup.sfssecgroup.id
}


resource "g42cloud_networking_secgroup_rule" "sfs_allow_2049" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2049
  port_range_max    = 2052
  remote_ip_prefix  = module.vpc.vpc_cidr
  security_group_id = g42cloud_networking_secgroup.sfssecgroup.id
}

resource "g42cloud_networking_secgroup_rule" "sfs_allow_20048" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 20048
  port_range_max    = 20048
  remote_ip_prefix  = module.vpc.vpc_cidr
  security_group_id = g42cloud_networking_secgroup.sfssecgroup.id
}

resource "g42cloud_sfs_turbo" "sfs-turbo-1" {
  name              = "sfs-turbo-1"
  size              = 500
  share_proto       = "NFS"
  vpc_id            = module.vpc.vpcid
  subnet_id         = module.vpc.subnetid
  security_group_id = g42cloud_networking_secgroup.sfssecgroup.id
  availability_zone = data.g42cloud_availability_zones.myaz.names[0]
}

data "huaweicloud_availability_zones" "myaz" {}

# Create a VPC.
resource "huaweicloud_vpc" "base_vpc" {
  name = var.vpc_name
  cidr = var.vpc_cidr
}

resource "huaweicloud_vpc_subnet" "subnet_1" {
  vpc_id      = huaweicloud_vpc.base_vpc.id
  name        = var.subnet_name
  cidr        = var.subnet_cidr
  gateway_ip  = var.subnet_gateway
  primary_dns = var.primary_dns
}

resource "huaweicloud_vpc_eip" "cce" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "cce-apiserver"
    size        = 20
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_vpc_eip" "nat" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "NAT"
    size        = 100
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

resource "huaweicloud_nat_gateway" "nat_1" {
  name      = var.nat_name
  spec      = "1"
  vpc_id    = huaweicloud_vpc.base_vpc.id
  subnet_id = huaweicloud_vpc_subnet.subnet_1.id
}

resource "huaweicloud_nat_snat_rule" "snat_1" {
  nat_gateway_id = huaweicloud_nat_gateway.nat_1.id
  floating_ip_id = huaweicloud_vpc_eip.nat.id
  subnet_id      = huaweicloud_vpc_subnet.subnet_1.id
}

resource "huaweicloud_compute_keypair" "node-keypair" {
  name       = var.key_pair_name
  public_key = var.public_key
}

resource "huaweicloud_cce_cluster" "cluster" {
  name                   = var.cce_cluster_name
  cluster_type           = "VirtualMachine"
  cluster_version        = "v1.19.10-r0"
  flavor_id              = "cce.s1.small"
  vpc_id                 = huaweicloud_vpc.base_vpc.id
  subnet_id              = huaweicloud_vpc_subnet.subnet_1.id
  container_network_type = "overlay_l2"
  authentication_mode    = "rbac"
  eip                    = huaweicloud_vpc_eip.cce.address
  delete_all             = "true"
}

resource "huaweicloud_cce_node" "cce-node1" {
  cluster_id        = huaweicloud_cce_cluster.cluster.id
  name              = var.node_name
  flavor_id         = var.node_flavor
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  key_pair          = var.key_pair_name

  root_volume {
    size       = var.root_volume_size
    volumetype = var.root_volume_type
  }
  data_volumes {
    size       = var.data_volume_size
    volumetype = var.data_volume_type
  }
}

# resource "local_file" "kubeconfig" {
#   content  = huaweicloud_cce_cluster.cluster.kube_config_raw
#   filename = "$Local kubeconfig file path"
# }

resource "huaweicloud_networking_secgroup" "secgroup" {
  name        = "rds_security_group"
  description = "security group for RDS"
}

resource "huaweicloud_rds_instance" "rds_instance" {
  name              = "mysql_instance"
  flavor            = var.rds_flavor
  vpc_id            = huaweicloud_vpc.base_vpc.id
  subnet_id         = huaweicloud_vpc_subnet.subnet_1.id
  security_group_id = huaweicloud_networking_secgroup.secgroup.id
  availability_zone = [data.huaweicloud_availability_zones.myaz.names[0]]
  # ha_replication_mode = "async"
  # availability_zone = [
  #   data.huaweicloud_availability_zones.myaz.names[0],
  #   data.huaweicloud_availability_zones.myaz.names[1]
  # ]

  db {
    type     = "MySQL"
    version  = var.rds_mysql_version
    password = var.rds_password
  }
  volume {
    type = "CLOUDSSD"
    size = 40
  }
  backup_strategy {
    start_time = "08:00-09:00"
    keep_days  = 1
  }
}

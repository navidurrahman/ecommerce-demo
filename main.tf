data "g42cloud_availability_zones" "myaz" {}

# Create a VPC.
resource "g42cloud_vpc" "base_vpc" {
  name = var.vpc_name
  cidr = var.vpc_cidr
}

resource "g42cloud_vpc_subnet" "subnet_1" {
  vpc_id      = g42cloud_vpc.base_vpc.id
  name        = var.subnet_name
  cidr        = var.subnet_cidr
  gateway_ip  = var.subnet_gateway
  primary_dns = var.primary_dns
}

resource "g42cloud_vpc_eip" "cce" {
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

resource "g42cloud_vpc_eip" "nat" {
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

resource "g42cloud_nat_gateway" "nat_1" {
  name      = var.nat_name
  spec      = "1"
  vpc_id    = g42cloud_vpc.base_vpc.id
  subnet_id = g42cloud_vpc_subnet.subnet_1.id
}

resource "g42cloud_nat_snat_rule" "snat_1" {
  nat_gateway_id = g42cloud_nat_gateway.nat_1.id
  floating_ip_id = g42cloud_vpc_eip.nat.id
  subnet_id      = g42cloud_vpc_subnet.subnet_1.id
}

resource "g42cloud_compute_keypair" "node-keypair" {
  name       = var.key_pair_name
  public_key = var.public_key
}

resource "g42cloud_cce_cluster" "cluster" {
  name                   = var.cce_cluster_name
  cluster_type           = "VirtualMachine"
  cluster_version        = var.cce_cluster_version
  flavor_id              = var.cce_cluster_flavor
  vpc_id                 = g42cloud_vpc.base_vpc.id
  subnet_id              = g42cloud_vpc_subnet.subnet_1.id
  container_network_type = "overlay_l2"
  authentication_mode    = "rbac"
  eip                    = g42cloud_vpc_eip.cce.address
  delete_all             = "true"
}

resource "g42cloud_cce_node" "cce-node1" {
  cluster_id        = g42cloud_cce_cluster.cluster.id
  name              = var.node_name
  flavor_id         = var.node_flavor
  os                = var.cce_node_os
  subnet_id         = g42cloud_vpc_subnet.subnet_1.id
  availability_zone = data.g42cloud_availability_zones.myaz.names[0]
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
#   content  = g42cloud_cce_cluster.cluster.kube_config_raw
#   filename = "$Local kubeconfig file path"
# }

resource "g42cloud_networking_secgroup" "secgroup" {
  name        = "rds_security_group"
  description = "security group for RDS"
}

resource "g42cloud_rds_instance" "rds_instance" {
  name              = "mysql_instance"
  flavor            = var.rds_flavor
  vpc_id            = g42cloud_vpc.base_vpc.id
  subnet_id         = g42cloud_vpc_subnet.subnet_1.id
  security_group_id = g42cloud_networking_secgroup.secgroup.id
  availability_zone = [data.g42cloud_availability_zones.myaz.names[0]]

  # For High Availibility
  # ha_replication_mode = "async"
  # availability_zone = [
  #   data.g42cloud_availability_zones.myaz.names[0],
  #   data.g42cloud_availability_zones.myaz.names[1]
  # ]

  db {
    type     = "MySQL"
    version  = var.rds_mysql_version
    password = var.rds_password
    port     = var.rds_port
  }
  volume {
    type = "ULTRAHIGH"
    size = 40
  }
  backup_strategy {
    start_time = "08:00-09:00"
    keep_days  = 1
  }
}

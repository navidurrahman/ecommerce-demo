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

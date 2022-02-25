variable "G42_ACCESS_KEY" {
  default = "ACCESS_KEY"
}

variable "G42_SECRET_KEY" {
  default = "SECRET_KEY"
}

variable "G42_ACCOUNT_NAME" {
  default = "ACCOUNT_NAME"
}

variable "G42VB_ACCESS_KEY" {
  default = "ACCESS_KEY"
}

variable "G42VB_SECRET_KEY" {
  default = "SECRET_KEY"
}

variable "G42VB_ACCOUNT_NAME" {
  default = "ACCOUNT_NAME"
}

variable "rds_password" {
  default = "fake-password"
}

variable "vpc_name" {
  default = "tbx-vpc"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet_name" {
  default = "tbx-subent"
}

variable "subnet_cidr" {
  default = "172.16.10.0/24"
}

variable "subnet_gateway" {
  default = "172.16.10.1"
}

variable "primary_dns" {
  default = "100.125.3.250"
}

variable "secondary_dns" {
  default = "100.125.2.14"
}

variable "nat_name" {
  default = "tbx-nat"
}

variable "rds_flavor" {
  default = "rds.mysql.c6.large.2"
}

variable "rds_mysql_version" {
  default = "8.0"
}

variable "rds_port" {
  default = 3306
}

################

variable "bandwidth_name" {
  default = "tbx-bandwidth"
}

variable "key_pair_name" {
  default = "tbx-key"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXLu5uASHVRMlcnuBYOoo6nPwMYhABM4ToB0Com6rjQZE/XGOz2qaj5wFDI+EQjXyGMrNbr2NhxGimRR5fsnkHnaDqSV7/aT9dElYjJiVHWOSpw50GbabrKDbEFkhzcRRyV9qODIoBEh0xKkqMtAH8+lZgmU4HVP1mTe8MPHTJSySVvstJwM88/fxuCjtDCG4wmKmi4LS8SEvgzb3bu42zRCwnhDwR+HOzlg61Qwg2I603kggVFTQDqN0pPTkolWrG4uRYzIJQoC5/m9gAEqRjurBNPBvIhoa4YBTDk1hxIdYlmvMV2SrqqJKQAV1ykmrorZ4uUdyAPBFXpsLai7Hr nrahman@Naveeds-MacBook-Pro.local"
}

variable "cce_cluster_name" {
  default = "tbx-cce"
}

variable "cce_cluster_flavor" {
  default = "cce.s2.small"
}

variable "cce_cluster_version" {
  default = "v1.19.10-r0"
}

variable "node_name" {
  default = "tbx-node-1"
}

variable "node2_name" {
  default = "tbx-node-2"
}


variable "node_flavor" {
  default = "s6.large.2"
}

variable "root_volume_size" {
  default = 40
}

variable "root_volume_type" {
  default = "SAS"
}

variable "data_volume_size" {
  default = 100
}

variable "data_volume_type" {
  default = "SAS"
}

variable "ecs_name" {
  default = "tbx-ecs"
}

variable "cce_node_os" {
  default = "CentOS 7.6"
}

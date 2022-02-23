variable "vpc_name" {
  default = "vpc-basic"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet_name" {
  default = "subent-basic"
}

variable "subnet_cidr" {
  default = "172.16.10.0/24"
}

variable "subnet_gateway" {
  default = "172.16.10.1"
}

variable "primary_dns" {
  default = "100.125.1.250"
}

variable "secondary_dns" {
  default = "100.125.21.250"
}

variable "nat_name" {
  default = "public-nat"
}

################

variable "bandwidth_name" {
  default = "tbxbandwidth"
}

variable "key_pair_name" {
  default = "node_key"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXLu5uASHVRMlcnuBYOoo6nPwMYhABM4ToB0Com6rjQZE/XGOz2qaj5wFDI+EQjXyGMrNbr2NhxGimRR5fsnkHnaDqSV7/aT9dElYjJiVHWOSpw50GbabrKDbEFkhzcRRyV9qODIoBEh0xKkqMtAH8+lZgmU4HVP1mTe8MPHTJSySVvstJwM88/fxuCjtDCG4wmKmi4LS8SEvgzb3bu42zRCwnhDwR+HOzlg61Qwg2I603kggVFTQDqN0pPTkolWrG4uRYzIJQoC5/m9gAEqRjurBNPBvIhoa4YBTDk1hxIdYlmvMV2SrqqJKQAV1ykmrorZ4uUdyAPBFXpsLai7Hr nrahman@Naveeds-MacBook-Pro.local"
}

variable "cce_cluster_name" {
  default = "tbxcce"
}

variable "cce_cluster_flavor" {
  default = "cce.s1.small"
}

variable "node_name" {
  default = "tbxnode"
}

variable "node_flavor" {
  default = "t6.large.2"
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

variable "ecs_flavor" {
  default = "sn3.large.2"
}

variable "ecs_name" {
  default = "tbxecs"
}

variable "os" {
  default = "EulerOS 2.5"
}

variable "image_name" {
  default = "EulerOS 2.5 64bit"
}
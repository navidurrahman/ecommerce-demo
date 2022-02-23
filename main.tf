# Create a VPC.
resource "huaweicloud_vpc" "base-vpc" {
  name = "terraform_vpc"
  cidr = "192.168.0.0/16"
}

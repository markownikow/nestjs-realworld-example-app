data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.10.0.0/16"
  azs = data.aws_availability_zones.available.names

  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets  = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
  database_subnets = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]

  enable_dns_hostnames = true
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    managed-by = "terraform"
    Environment = var.env
  }
}


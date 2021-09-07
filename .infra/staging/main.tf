
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  backend "s3" {
    dynamodb_table = "terraform-locks"
    bucket = "otrium-terraform-states"
    encrypt = true
    key = "test/staging/terraform.tfstate"
    region = "eu-central-1"
    profile = "terraformproduser"
  }
}


module "main" {
  source = "../"
  apply_immediately = true
  app_instance_type = "c5.large"
  db_instance_type = "db.t3.xlarge"
  db_storage_size = 20
  db_name = "nestjsrealworld"
  db_username = "prisma"
  instance_name = "node-app"
}

output "db-password" {
  value = module.main.db-password

}

output "ssh-key" {
  value = module.main.ssh-key
}

output "ip" {
  value = module.main.ip
}

output "db_dns" {
  value = module.main.db
}
variable "aws_access_key" {
  default = ""
}
variable "aws_secret_key" {
  default = ""
}

variable "aws_region" {
  default = "eu-central-1"
}
variable "app_instance_type" {
  default = ""
}

variable "instance_name" {
  default = ""
}

variable "db_instance_type" {
  default = ""
}
variable "db_storage_size" {
  default = ""
}
variable "db_username" {
  default = ""
}


variable "env" {
  default = "staging"
}
variable "vpc_name" {
  default = "node-app"
}

variable "apply_immediately" {}
resource "random_string" "db-password" {
  length = 10
}


variable "db_name" {
  default = ""
}
resource "aws_security_group" "db-access" {
  name        = "${var.db_name}SG"
  description = "Allows traffic to db ${var.db_name}"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "sg-db-${var.db_name}"
    managed-by = "terraform"
  }
}

resource "aws_security_group_rule" "allow_all_egress_db" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.db-access.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_db_apps" {
  from_port = 5432
  protocol = "tcp"
  security_group_id = aws_security_group.db-access.id
  to_port = 5432
  description = "allows db traffic from apps"
  type = "ingress"
  source_security_group_id = aws_security_group.apps-sg.id

}



resource "aws_db_instance" "db" {
  allocated_storage    = var.db_storage_size
  engine               = "postgres"
  instance_class       = var.db_instance_type
  name                 = var.db_name
  username             = var.db_username
  password             = random_string.db-password.result
  skip_final_snapshot  = true
  db_subnet_group_name = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.db-access.id]
  apply_immediately = var.apply_immediately
}

output "db-password" {
  value = random_string.db-password.result
//  sensitive = true
}

output "db" {
  value = aws_db_instance.db.endpoint
}
resource "tls_private_key" "ec2-sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "aws_key_pair" "generated_ec2_key" {
  key_name   = "TEST_EC2_KEY"
  public_key = tls_private_key.ec2-sshkey.public_key_openssh
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_security_group" "apps-sg" {
  name        = "AppsSG"
  description = "Allows traffic to apps"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "sg-apps"
  }
}

resource "aws_security_group_rule" "allow_all_egress" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.apps-sg.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_http" {
  from_port = 3000
  protocol = "tcp"
  security_group_id = aws_security_group.apps-sg.id
  to_port = 3000
  type = "ingress"
  description = "allows node app http traffic"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_ssh" {
  from_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.apps-sg.id
  to_port = 22
  type = "ingress"
  description = "allows node app ssh traffic"
  cidr_blocks = ["0.0.0.0/0"]
}



resource "aws_instance" "apps-ec2" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.app_instance_type
  key_name      = aws_key_pair.generated_ec2_key.key_name

  vpc_security_group_ids = [
    aws_security_group.apps-sg.id
  ]

  subnet_id = module.vpc.public_subnets[0]

  tags = {
    Name = var.instance_name
  }
}

output "ssh-key" {
  value = tls_private_key.ec2-sshkey.private_key_pem
//  sensitive = true
}

output "ip" {
  value = aws_instance.apps-ec2.public_ip
}
data "aws_ami" "ubuntu" {
  owners      = [var.aws_ami_owners]
  most_recent = true

  filter {
    name   = "name"
    values = [var.aws_instance_os_distro]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.env}-snehal-devops-key"
  public_key = file("${path.root}/${var.public_key_path}")
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_sg" {
  name        = "${var.env}-devops-sg"
  description = "SG for every instance"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name        = "${var.env}-devops-sg"
    Environment = var.env
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.my_sg.id
  description       = "Allow SSH"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.my_sg.id
  description       = "Allow HTTP"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.my_sg.id
  description       = "Allow HTTPS"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.my_sg.id
  description       = "Allow All"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "my_instance" {
  count           = var.instance_count
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.my_sg.name]

  root_block_device {
    volume_size = var.instance_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name        = "${var.env}-devops-instance"
    Environment = var.env
  }
}

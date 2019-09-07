provider "aws" {
  region = "eu-central-1"
}

data "template_file" "bootstrap-script" {
  template = "${file("${path.module}/templates/bootstrap.sh")}"

  vars {
    bastion_port        = "${var.bastion_port}"
    bastion_ip          = "${var.bastion_ip}"
    bastion_private_key = "${var.bastion_private_key}"
    client_public_key   = "${var.client_public_key}"
    client_ip           = "${var.client_ip}"
  }
}

resource "aws_instance" "wireguard-bastion" {
  ami             = "${var.ubuntu_ami}"
  instance_type   = "t2.micro"
  key_name        = "wireguard-bastion"
  user_data       = "${data.template_file.bootstrap-script.rendered}"
  security_groups = ["wireguard-bastion"]
  tags            = "${merge(var.tags, map("Name", "wireguard-bastion"))}"
}

resource "aws_security_group" "wireguard-bastion" {
  name        = "wireguard-bastion"
  description = "Allow incoming VPN traffic and all outgoing"

  ingress {
    from_port   = "${var.bastion_port}"
    to_port     = "${var.bastion_port}"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "wireguard-bastion"))}"
}

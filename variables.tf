variable "tags" {
  description = "Tags dictionary to pass for all modules"
  type        = "map"

  default = {
    Project = "wireguard-bastion"
  }
}

variable "ubuntu_ami" {
  type        = "string"
  description = "AMI of Ubuntu image"
  default     = "ami-0ac05733838eabc06" # eu-central-1
}

variable "bastion_port" {
  type    = "string"
  default = "51999"
}

variable "bastion_ip" {
  type    = "string"
  default = "10.200.63.40/16"
}

variable "bastion_private_key" {
  type    = "string"
  default = "BASTION_PRIVATE_KEY"
}

variable "client_public_key" {
  type    = "string"
  default = "CLIENT_PUBLIC_KEY"
}

variable "client_ip" {
  type    = "string"
  default = "10.200.63.20/32"
}

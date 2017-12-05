data "aws_ami" "vRouter" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*EOS*"]

    #values = ["*VEOS"]
    #values = ["*EFT1"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["083837402522"] # Arista

  #owners = ["679593333241"] # Arista (Marketplace)
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_instance_type" {
  default = "m4.large"
}

variable "tag_name_prefix" {
  default = ""
}

variable "tag_department" {
  default = "SE"
}

variable "tag_author" {}

variable "tag_environment" {
  default = "sandbox"
}

variable "tag_autostop" {
  default = "yes"
}

variable "tag_description" {
  default = ""
}

variable "keypair_name" {
  default = "jere-cvp-key"
}

variable "public_key" {}

variable "key_path" {
  description = "Path to the SSH public_key"
  default     = "/Users/jere/.ssh/id_rsa.pub"
}

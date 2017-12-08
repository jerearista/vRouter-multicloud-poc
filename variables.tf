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

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Amazon-Linux-64bit-HVM*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  #owners = ["531700196402"] # Amazon
}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Core-Base*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  #owners = ["531700196402"] # amazon
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vrouter_ami" {
  default = "ami-2fe8c64a"
}

variable "jump_ami" {
  # AmazonLinux
  default = "ami-157b2102"

  # Windows_Server-2016-English-Nano-Base-2017.09.13
  #default = "ami-5fd6f43a"

  # ? Windows_Server-2016-English-Nano-Base-2017.09.13
}

variable "app_ami" {
  # AmazonLinux
  default = "ami-157b2102"
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

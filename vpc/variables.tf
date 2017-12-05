variable "name" {}

variable "net_prefix" {
  default = "10.115"
}

variable "octet" {}
variable "keypair_name" {}

variable "aws_region" {
  default = "us-east-1"
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

variable "vrouter_ami" {
  default = "ami-2fe8c64a"
}

variable "jump_ami" {
  # Windows_Server-2016-English-Nano-Base-2017.09.13
  default = "ami-5fd6f43a"

  # ? Windows_Server-2016-English-Nano-Base-2017.09.13
}

variable "app_ami" {
  # AmazonLinux
  default = "ami-6b39150e"
}

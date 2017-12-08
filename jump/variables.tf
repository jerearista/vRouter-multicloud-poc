variable "jump_ami" {
  # AmazonLinux
  default = "ami-157b2102"

  # Windows_Server-2016-English-Nano-Base-2017.09.13
  #default = "ami-5fd6f43a"

  # ? Windows_Server-2016-English-Nano-Base-2017.09.13
}

variable "aws_instance_type" {
  default = "t2.micro"

  #default = "m4.large"
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

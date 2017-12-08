variable "name" {}

variable "net_prefix" {
  default = "10.115"
}

variable "octet" {}
variable "keypair_name" {}

variable "aws_instance_type" {
  default = "t2.micro"

  #default = "m4.large"
}

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

variable "jump_host_id" {}
variable "jump_vpc_id" {}
variable "jump_cidr_block" {}
variable "jump_main_route_table_id" {}

/**
 * Make AWS account ID available.
 *
 * This is added as an output so that other stacks can reference this. Usually
 * required for VPC peering.
 */
data "aws_caller_identity" "current" {}

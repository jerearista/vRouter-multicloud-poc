provider "aws" {
  version = "~> 0.1"
  region  = "${var.aws_region}"

  #region = "us-east-1"
  #region = "us-east-2"
  #region = "us-west-1"
  profile = "prod"
}

/**
 * Make AWS account ID available.
 *
 * This is added as an output so that other stacks can reference this. Usually
 * required for VPC peering.
 */
data "aws_caller_identity" "current" {}

module "VPC-112" {
  source = "./vpc"

  keypair_name    = "${var.keypair_name}"
  aws_region      = "${var.aws_region}"
  tag_name_prefix = "${var.tag_name_prefix}"
  tag_department  = "${var.tag_department}"
  tag_author      = "${var.tag_author}"
  tag_environment = "${var.tag_environment}"
  tag_autostop    = "${var.tag_autostop}"
  tag_description = "${var.tag_description}"
  vrouter_ami     = "${data.aws_ami.vRouter.id}"

  #jump_ami        =
  #app_ami         =

  name       = "VPC-112"
  net_prefix = "10.115"
  octet      = "112"
}

module "VPC-115" {
  source = "./vpc"

  keypair_name    = "${var.keypair_name}"
  aws_region      = "${var.aws_region}"
  tag_name_prefix = "${var.tag_name_prefix}"
  tag_department  = "${var.tag_department}"
  tag_author      = "${var.tag_author}"
  tag_environment = "${var.tag_environment}"
  tag_autostop    = "${var.tag_autostop}"
  tag_description = "${var.tag_description}"
  vrouter_ami     = "${data.aws_ami.vRouter.id}"

  #jump_ami        =
  #app_ami         =

  name       = "VPC-115"
  net_prefix = "10.115"
  octet      = "115"
}

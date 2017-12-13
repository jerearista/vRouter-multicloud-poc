terraform {
  required_version = ">= 0.10"
}

provider "aws" {
  version = "~> 0.1"
  region  = "${var.aws_region}"
  profile = "prod"
}

provider "template" {
  version = "~> 1.0"
}

/**
 * Make AWS account ID available.
 *
 * This is added as an output so that other stacks can reference this. Usually
 * required for VPC peering.
 */
data "aws_caller_identity" "current" {}

resource "aws_key_pair" "vrouter_key" {
  key_name   = "${var.keypair_name}"
  public_key = "${var.public_key}"

  #key_path = "${var.key_path}"
}

module "jump" {
  source = "./jump"

  keypair_name = "${var.keypair_name}"

  #jump_ami        = "${data.aws_ami.vRouter.id}"
  jump_ami = "${data.aws_ami.amazon_linux.id}"

  tag_name_prefix = "${var.tag_name_prefix}"
  tag_department  = "${var.tag_department}"
  tag_author      = "${var.tag_author}"
  tag_environment = "${var.tag_environment}"
  tag_autostop    = "${var.tag_autostop}"
  tag_description = "${var.tag_description}"
}

/*
module "VPC-112" {
  source = "./vpc"

  name       = "VPC-112"
  net_prefix = "10.115"
  octet      = "112"

  keypair_name    = "${var.keypair_name}"
  aws_region      = "${var.aws_region}"
  tag_name_prefix = "${var.tag_name_prefix}"
  tag_department  = "${var.tag_department}"
  tag_author      = "${var.tag_author}"
  tag_environment = "${var.tag_environment}"
  tag_autostop    = "${var.tag_autostop}"
  tag_description = "${var.tag_description}"
  vrouter_ami     = "${data.aws_ami.vRouter.id}"

  #app_ami = "ami-157b2102"
  app_ami = "${data.aws_ami.amazon_linux.id}"

  #jump_ami = "ami-157b2102"
  jump_ami                 = "${data.aws_ami.amazon_linux.id}"
  jump_host_id             = "${module.jump.host_id}"
  jump_vpc_id              = "${module.jump.vpc_id}"
  jump_cidr_block          = "${module.jump.cidr_block}"
  jump_main_route_table_id = "${module.jump.main_route_table_id}"

  #app_ami         =
}
*/

module "VPC-115" {
  source = "./vpc"

  name       = "VPC-115"
  net_prefix = "10.115"
  octet      = "115"

  keypair_name    = "${var.keypair_name}"
  aws_region      = "${var.aws_region}"
  tag_name_prefix = "${var.tag_name_prefix}"
  tag_department  = "${var.tag_department}"
  tag_author      = "${var.tag_author}"
  tag_environment = "${var.tag_environment}"
  tag_autostop    = "${var.tag_autostop}"
  tag_description = "${var.tag_description}"
  vrouter_ami     = "${data.aws_ami.vRouter.id}"

  #app_ami = "ami-157b2102"
  app_ami = "${data.aws_ami.amazon_linux.id}"

  #jump_ami = "ami-157b2102"
  jump_ami                 = "${data.aws_ami.amazon_linux.id}"
  jump_host_id             = "${module.jump.host_id}"
  jump_vpc_id              = "${module.jump.vpc_id}"
  jump_cidr_block          = "${module.jump.cidr_block}"
  jump_main_route_table_id = "${module.jump.main_route_table_id}"
}

/*

module "Transit_VPC-113" {
  source = "./transit_vpc"

  name       = "VPC-113"
  net_prefix = "10.115"
  octet      = "113"

  vrouter_ami = "${data.aws_ami.vRouter.id}"
  aws_region  = "${var.aws_region}"

  keypair_name    = "${var.keypair_name}"
  tag_name_prefix = "${var.tag_name_prefix}"
  tag_department  = "${var.tag_department}"
  tag_author      = "${var.tag_author}"
  tag_environment = "${var.tag_environment}"
  tag_autostop    = "${var.tag_autostop}"
  tag_description = "${var.tag_description}"

  #jump_ami = "ami-157b2102"
  jump_ami                 = "${data.aws_ami.amazon_linux.id}"
  jump_host_id             = "${module.jump.host_id}"
  jump_vpc_id              = "${module.jump.vpc_id}"
  jump_cidr_block          = "${module.jump.cidr_block}"
  jump_main_route_table_id = "${module.jump.main_route_table_id}"
}

module "Transit_VPC-114" {
  source = "./transit_vpc"

  name       = "VPC-114"
  net_prefix = "10.115"
  octet      = "114"

  vrouter_ami = "${data.aws_ami.vRouter.id}"

  aws_region      = "${var.aws_region}"
  keypair_name    = "${var.keypair_name}"
  tag_name_prefix = "${var.tag_name_prefix}"
  tag_department  = "${var.tag_department}"
  tag_author      = "${var.tag_author}"
  tag_environment = "${var.tag_environment}"
  tag_autostop    = "${var.tag_autostop}"
  tag_description = "${var.tag_description}"

  #jump_ami                 = "ami-157b2102"
  jump_ami                 = "${data.aws_ami.amazon_linux.id}"
  jump_host_id             = "${module.jump.host_id}"
  jump_vpc_id              = "${module.jump.vpc_id}"
  jump_cidr_block          = "${module.jump.cidr_block}"
  jump_main_route_table_id = "${module.jump.main_route_table_id}"
}
 */


/*
 * Setup VPC peering from 112 to 113
 */
/*
resource "aws_vpc_peering_connection" "112-113" {
  # Main VPC ID.
  vpc_id = "${module.VPC-112.vpc_id}"

  # AWS Account ID. This can be dynamically queried using the
  # aws_caller_identity data resource.
  # https://www.terraform.io/docs/providers/aws/d/caller_identity.html
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"

  # Secondary VPC ID.
  peer_vpc_id = "${module.Transit_VPC-113.vpc_id}"

  # Flags that the peering connection should be automatically confirmed. This
  # only works if both VPCs are owned by the same account.
  auto_accept = true

  tags {
    Name       = "${var.tag_name_prefix}112<>113"
    Department = "${var.tag_department}"
    Author = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_route" "112-113" {
  # ID of VPC 1 main route table.
  route_table_id = "${module.Transit_VPC-113.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${module.VPC-112.upstream_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.112-113.id}"
}

resource "aws_route" "113-112" {
  # ID of VPC 2 main route table.
  route_table_id = "${module.VPC-112.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${module.Transit_VPC-113.downstream_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.112-113.id}"
}
*/


/*
 * Setup VPC peering from 114 to 113
 */
/*
resource "aws_vpc_peering_connection" "114-113" {
  # Main VPC ID.
  #vpc_id = "${aws_vpc.Jump_VPC.id}"
  vpc_id = "${module.Transit_VPC-114.vpc_id}"

  # AWS Account ID. This can be dynamically queried using the
  # aws_caller_identity data resource.
  # https://www.terraform.io/docs/providers/aws/d/caller_identity.html
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"

  # Secondary VPC ID.
  peer_vpc_id = "${module.Transit_VPC-113.vpc_id}"

  # Flags that the peering connection should be automatically confirmed. This
  # only works if both VPCs are owned by the same account.
  auto_accept = true

  tags {
    Name        = "${var.tag_name_prefix}114<>113"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_route" "114-113" {
  # ID of VPC 1 main route table.
  route_table_id = "${module.Transit_VPC-113.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${module.Transit_VPC-114.upstream_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.114-113.id}"
}

resource "aws_route" "113-114" {
  # ID of VPC 2 main route table.
  route_table_id = "${module.Transit_VPC-114.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${module.Transit_VPC-113.upstream_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.114-113.id}"
}
*/
/*
 * Setup VPC peering from 114 to 115
 */


/*
resource "aws_vpc_peering_connection" "114-115" {
  # Main VPC ID.
  #vpc_id = "${aws_vpc.Jump_VPC.id}"
  vpc_id = "${module.VPC-115.vpc_id}"

  # AWS Account ID. This can be dynamically queried using the
  # aws_caller_identity data resource.
  # https://www.terraform.io/docs/providers/aws/d/caller_identity.html
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"

  # Secondary VPC ID.
  peer_vpc_id = "${module.Transit_VPC-114.vpc_id}"

  # Flags that the peering connection should be automatically confirmed. This
  # only works if both VPCs are owned by the same account.
  auto_accept = true

  tags {
    Name        = "${var.tag_name_prefix}114<>115"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_route" "114-115" {
  # ID of VPC 1 main route table.
  route_table_id = "${module.Transit_VPC-114.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${module.VPC-115.upstream_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.114-115.id}"
}

resource "aws_route" "115-114" {
  # ID of VPC 2 main route table.
  route_table_id = "${module.VPC-115.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${module.Transit_VPC-114.downstream_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.114-115.id}"
}
*/


resource "aws_key_pair" "vrouter_key" {
  key_name   = "${var.keypair_name}"
  public_key = "${var.public_key}"

  #key_path = "${var.key_path}"
}

resource "aws_vpc" "Jump_VPC" {
  cidr_block = "10.115.100.0/24"

  tags {
    Name       = "${var.tag_name_prefix}Jump-VPC"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }

  # DHCP Options
  # route table: rtb-a1503bda
  # Network ACL: acl-b14af3c9 (Allow all in/out)
  # DNS hostnames: no
}

resource "aws_subnet" "VPC_jump" {
  vpc_id                  = "${aws_vpc.Jump_VPC.id}"
  cidr_block              = "10.115.100.0/28"
  map_public_ip_on_launch = true

  #availability_zone = "us-east-1a"
  #availability_zone = "us-east-2a"
  tags {
    Name       = "${var.tag_name_prefix}Jump-subnet"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }

  depends_on = ["aws_internet_gateway.Jump_IGW"]
}

resource "aws_internet_gateway" "Jump_IGW" {
  vpc_id = "${aws_vpc.Jump_VPC.id}"

  tags {
    Name       = "${var.tag_name_prefix}Jump_IGW"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.Jump_VPC.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.Jump_IGW.id}"
}

### Assoc subnet with default route id ###
#resource "aws_route_table_association" "a" {
#  subnet_id = "${aws_subnet.VPC_jump_subnet.id}"
#  route_table_id = "${aws_vpc.Jump_VPC.default_route_table_id}"
#}

resource "aws_security_group" "external_access" {
  name        = "LOB-VPC-Security_group"
  description = "SSH and ICMP from anywhere"
  vpc_id      = "${aws_vpc.Jump_VPC.id}"

  tags {
    Name       = "${var.tag_name_prefix}external-access"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }

  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3389
    to_port     = 3389
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["10.115.0.0/16"]

    # "${aws_vpc.primary.cidr_block}",
    # "${aws_vpc.secondary.cidr_block}",
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

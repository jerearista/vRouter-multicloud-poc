resource "aws_vpc" "VPC" {
  cidr_block = "${var.net_prefix}.${var.octet}.0/24"

  tags {
    Name       = "${var.tag_name_prefix}${var.name}"
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

resource "aws_subnet" "upstream" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.net_prefix}.${var.octet}.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags {
    Name       = "${var.tag_name_prefix}Upstream-subnet"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

resource "aws_subnet" "downstream" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.net_prefix}.${var.octet}.16/28"
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}a"

  tags {
    Name       = "${var.tag_name_prefix}Downstream-subnet"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

resource "aws_subnet" "mgmt" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.net_prefix}.${var.octet}.32/28"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags {
    Name       = "${var.tag_name_prefix}Mgmt-subnet"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

resource "aws_route_table" "downstream" {
  vpc_id = "${aws_vpc.VPC.id}"

  tags {
    Name       = "${var.tag_name_prefix}downstream"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

# Get info for the automatically created main route table and make
#   our new route table the new main
#resource "aws_main_route_table_association" "jj-LOB-1-WEB-main" {
#  vpc_id = "${aws_vpc.jere-vr-LOB-VPC-1.id}"
#  route_table_id = "${aws_route_table.jj-LOB-1-WEB.id}"
#}

#resource "aws_route_table_association" "jj-LOB-VPC-1" {
#  subnet_id = "${aws_subnet.jj-10_2_1_0.id}"
#  route_table_id = "${aws_route_table.jj-LOB-1-WEB.id}"
#}

#resource "aws_route" "jj-LOB-internet_access" {
#  route_table_id = "${aws_route_table.jj-LOB-1-WEB.id}"
#  #route_table_id = "${aws_vpc.jere-vr-LOB-VPC-1.main_route_table_id}"
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = "${aws_internet_gateway.jj-LOB-IGW.id}"
#  depends_on = ["aws_route_table.jj-LOB-1-WEB"]
#}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.VPC.default_route_table_id}"

  #route {
  #  cidr_block = "10.2.1.0/24"
  #  gateway_id = "${aws_internet_gateway.jj-LOB-IGW.id}"
  #}
  #route {
  #  cidr_block = "0.0.0.0/0"
  #  gateway_id = "${aws_internet_gateway.jj-LOB-IGW.id}"
  #}
  tags {
    Name       = "${var.tag_name_prefix}VPC-${var.octet}-RT"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

### Assoc subnet with default route id ###
resource "aws_route_table_association" "upstream" {
  subnet_id      = "${aws_subnet.upstream.id}"
  route_table_id = "${aws_vpc.VPC.default_route_table_id}"
}

resource "aws_route_table_association" "mgmt" {
  subnet_id      = "${aws_subnet.mgmt.id}"
  route_table_id = "${aws_vpc.VPC.default_route_table_id}"
}

resource "aws_route_table_association" "downstream" {
  subnet_id      = "${aws_subnet.downstream.id}"
  route_table_id = "${aws_route_table.downstream.id}"
}

#resource "aws_route" "jj-LOB-internet_access" {
#  route_table_id = "${aws_vpc.jere-vr-LOB-VPC-1.default_route_table_id}"
#  #route_table_id = "${aws_route_table.jj-rt-LOB-1-WEB.id}"
#  #route_table_id = "${aws_vpc.jere-vr-LOB-VPC-1.main_route_table_id}"
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = "${aws_internet_gateway.jj-LOB-IGW.id}"
#  #depends_on = ["aws_route_table.jj-rt-LOB-1-WEB"]
#}

resource "aws_network_interface" "vr-eth1" {
  subnet_id = "${aws_subnet.mgmt.id}"

  #security_groups = ["${aws_security_group.security_group.id}"]
  source_dest_check = false
  private_ips       = ["${var.net_prefix}.${var.octet}.37"]

  tags {
    Name       = "${var.tag_name_prefix}${var.octet}-vr-eth1"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

resource "aws_network_interface" "vr-eth2" {
  subnet_id = "${aws_subnet.upstream.id}"

  #security_groups = ["${aws_security_group.security_group.id}"]
  source_dest_check = false
  private_ips       = ["${var.net_prefix}.${var.octet}.6"]

  tags {
    Name       = "${var.tag_name_prefix}${var.octet}-vr-eth2"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
    Department = "${var.tag_department}"
  }
}

resource "aws_network_interface" "vr-eth3" {
  subnet_id = "${aws_subnet.downstream.id}"

  #security_groups = ["${aws_security_group.security_group.id}"]
  source_dest_check = false
  private_ips       = ["${var.net_prefix}.${var.octet}.21"]

  tags {
    Name       = "${var.tag_name_prefix}${var.octet}-vr-eth3"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

/*
 * Image_type affects the maximum # of network interfaces
 * http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
 */
resource "aws_instance" "vRouter" {
  ami = "${var.vrouter_ami}"

  #instance_type = "m4.large"

  instance_type = "c4.xlarge"
  instance_initiated_shutdown_behavior = "stop"

  # disable_api_termination - (Optional) If true, enables EC2 Instance Termination Protection

  network_interface {
    network_interface_id = "${aws_network_interface.vr-eth1.id}"
    device_index         = 0
  }
  network_interface {
    network_interface_id = "${aws_network_interface.vr-eth2.id}"
    device_index         = 1
  }
  network_interface {
    network_interface_id = "${aws_network_interface.vr-eth3.id}"
    device_index         = 2
  }
  key_name = "${var.keypair_name}"
  tags {
    Name       = "${var.tag_name_prefix}${var.octet}-vRouter"
    Department = "${var.tag_department}"
    Department = "${var.tag_author}"
    Department = "${var.tag_environment}"
    Department = "${var.tag_autostop}"
    Department = "${var.tag_description}"
  }
}

#resource "aws_network_interface_attachment" "Eth3" {
#  instance_id          = "${aws_instance.vRouter.id}"
#  network_interface_id = "${aws_network_interface.vr-eth3.id}"
#  device_index         = 2
#}

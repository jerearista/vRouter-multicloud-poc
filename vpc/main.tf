resource "aws_vpc" "VPC" {
  cidr_block = "${var.net_prefix}.${var.octet}.0/24"

  tags {
    Name        = "${var.tag_name_prefix}${var.name}"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_default_security_group" "default" {
  #name        = "${var.tag_name_prefix}${var.octet}"
  #description = "SSH and ICMP from anywhere"
  vpc_id = "${aws_vpc.VPC.id}"

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }

  // Begin AWS Defaults
  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  // End AWS Defaults

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
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
    cidr_blocks = ["${var.net_prefix}.0.0/16"]
  }
}

resource "aws_subnet" "upstream" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.net_prefix}.${var.octet}.0/28"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags {
    Name        = "${var.tag_name_prefix}${var.name}-Upstream"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_subnet" "downstream" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.net_prefix}.${var.octet}.16/28"
  map_public_ip_on_launch = false
  availability_zone       = "${var.aws_region}a"

  tags {
    Name        = "${var.tag_name_prefix}${var.name}-Downstream"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_subnet" "mgmt" {
  vpc_id                  = "${aws_vpc.VPC.id}"
  cidr_block              = "${var.net_prefix}.${var.octet}.32/28"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags {
    Name        = "${var.tag_name_prefix}${var.name}-Mgmt"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_route_table" "downstream" {
  vpc_id = "${aws_vpc.VPC.id}"

  tags {
    Name        = "${var.tag_name_prefix}${var.name}-downstream"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = "${aws_route_table.downstream.id}"
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = "${aws_network_interface.vr-eth3.id}"
}

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
    Name        = "${var.tag_name_prefix}VPC-${var.octet}-default"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
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

resource "aws_network_interface" "vr-eth1" {
  subnet_id = "${aws_subnet.mgmt.id}"

  #security_groups = ["${aws_security_group.security_group.id}"]
  source_dest_check = false
  private_ips       = ["${var.net_prefix}.${var.octet}.37"]

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-vr-eth1"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_network_interface" "vr-eth2" {
  subnet_id = "${aws_subnet.upstream.id}"

  #security_groups = ["${aws_security_group.security_group.id}"]
  source_dest_check = false
  private_ips       = ["${var.net_prefix}.${var.octet}.6"]

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-vr-eth2"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_network_interface" "vr-eth3" {
  subnet_id = "${aws_subnet.downstream.id}"

  #security_groups = ["${aws_security_group.security_group.id}"]
  source_dest_check = false
  private_ips       = ["${var.net_prefix}.${var.octet}.21"]

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-vr-eth3"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

/*
 * Image_type affects the maximum # of network interfaces
 * http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI
 */
resource "aws_instance" "vRouter" {
  ami = "${var.vrouter_ami}"

  #instance_type = "m4.large"

  instance_type                        = "c4.xlarge"
  instance_initiated_shutdown_behavior = "stop"
  user_data                            = "${file("${path.root}/vRouter-${var.octet}-startup-config.txt")}"

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
    Name        = "${var.tag_name_prefix}${var.octet}-vRouter"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

// ********************************************************
// Example adding another interface to the vRouter 
// after the environment is up.

/*
resource "aws_network_interface" "vr-eth4" {
  subnet_id = "${aws_subnet.downstream.id}"

  #security_groups = ["${aws_security_group.security_group.id}"]
  source_dest_check = false
  private_ips       = ["${var.net_prefix}.${var.octet}.24"]

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-vr-eth4"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_network_interface_attachment" "Eth4" {
  instance_id          = "${aws_instance.vRouter.id}"
  network_interface_id = "${aws_network_interface.vr-eth4.id}"
  device_index         = 3
}
*/

// ********************************************************

resource "aws_network_interface" "jump-eth0" {
  subnet_id   = "${aws_subnet.mgmt.id}"
  private_ips = ["${var.net_prefix}.${var.octet}.38"]

  #security_groups = ["${aws_security_group.default.id}"]

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-jump_host-eth0"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_network_interface" "jump-eth1" {
  subnet_id   = "${aws_subnet.downstream.id}"
  private_ips = ["${var.net_prefix}.${var.octet}.22"]

  #security_groups = ["${aws_security_group.default.id}"]

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-jump_host-eth1"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_network_interface" "app-eth0" {
  subnet_id   = "${aws_subnet.downstream.id}"
  private_ips = ["${var.net_prefix}.${var.octet}.23"]

  #security_groups = ["${aws_security_group.default.id}"]

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-app_host-eth0"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_instance" "jump" {
  ami           = "${var.jump_ami}"
  instance_type = "${var.aws_instance_type}"

  instance_initiated_shutdown_behavior = "stop"

  network_interface {
    network_interface_id = "${aws_network_interface.jump-eth0.id}"
    device_index         = 0
  }

  network_interface {
    network_interface_id = "${aws_network_interface.jump-eth1.id}"
    device_index         = 1
  }

  key_name = "${var.keypair_name}"

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-jump_host"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #    "echo '10.115.100.10	jump-${var.octet}.localdomain jump-${var.octet}' >> /etc/hosts",
  #    "hostname jump-${var.octet}"
  #    #"ip route add 10.2.12.0/24 via 10.2.11.6"
  #    #"ip route replace default via 10.2.11.6"
  #  ]
  #}
}

resource "aws_instance" "app" {
  ami           = "${var.app_ami}"
  instance_type = "${var.aws_instance_type}"

  instance_initiated_shutdown_behavior = "stop"

  network_interface {
    network_interface_id = "${aws_network_interface.app-eth0.id}"
    device_index         = 0
  }

  key_name = "${var.keypair_name}"

  tags {
    Name        = "${var.tag_name_prefix}${var.octet}-app_host"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #    "echo '10.115.100.10	jump-${var.octet}.localdomain jump-${var.octet}' >> /etc/hosts",
  #    "hostname app-${var.octet}"
  #    #"ip route add 10.2.12.0/24 via 10.2.11.6"
  #    #"ip route replace default via 10.2.11.6"
  #  ]
  #}
}

/*
 * Setup VPC peering to the bastion VPC
 */
resource "aws_vpc_peering_connection" "vpc_to_jump" {
  # Main VPC ID.
  #vpc_id = "${aws_vpc.Jump_VPC.id}"
  vpc_id = "${var.jump_vpc_id}"

  # AWS Account ID. This can be dynamically queried using the
  # aws_caller_identity data resource.
  # https://www.terraform.io/docs/providers/aws/d/caller_identity.html
  peer_owner_id = "${data.aws_caller_identity.current.account_id}"

  # Secondary VPC ID.
  peer_vpc_id = "${aws_vpc.VPC.id}"

  # Flags that the peering connection should be automatically confirmed. This
  # only works if both VPCs are owned by the same account.
  auto_accept = true

  tags {
    Name        = "${var.tag_name_prefix}jump<>${var.octet}"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_route" "jump2thisvpc" {
  # ID of VPC 1 main route table.
  route_table_id = "${var.jump_main_route_table_id}"

  #route_table_id = "${aws_vpc.Jump_VPC.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  #destination_cidr_block = "${aws_vpc.VPC.cidr_block}"
  destination_cidr_block = "${aws_subnet.mgmt.cidr_block}"
  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_to_jump.id}"
}

resource "aws_route" "thisvpc2jump" {
  # ID of VPC 2 main route table.
  route_table_id = "${aws_vpc.VPC.main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  #destination_cidr_block = "${aws_vpc.Jump_VPC.cidr_block}"
  destination_cidr_block = "${var.jump_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_to_jump.id}"
}

// Jump VPC to "downstream" to access the app host
resource "aws_route" "jump2downstream" {
  # ID of VPC 1 main route table.
  route_table_id = "${var.jump_main_route_table_id}"

  # CIDR block / IP range for VPC 2.
  #destination_cidr_block = "${aws_vpc.VPC.cidr_block}"
  destination_cidr_block = "${aws_subnet.downstream.cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_to_jump.id}"
}

resource "aws_route" "downstream2jump" {
  # ID of VPC 2 main route table.
  route_table_id = "${aws_route_table.downstream.id}"

  # CIDR block / IP range for VPC 2.
  destination_cidr_block = "${var.jump_cidr_block}"

  # ID of VPC peering connection.
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpc_to_jump.id}"
}

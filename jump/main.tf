resource "aws_vpc" "Jump_VPC" {
  cidr_block = "10.115.100.0/24"

  tags {
    Name        = "${var.tag_name_prefix}Jump-VPC"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

//name the route table
resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.Jump_VPC.default_route_table_id}"

  #route {
  #  cidr_block = "10.2.1.0/24"
  #  gateway_id = "${aws_internet_gateway.jj-LOB-IGW.id}"
  #}
  #route {
  #  cidr_block = "0.0.0.0/0"
  #  gateway_id = "${aws_internet_gateway.jj-LOB-IGW.id}"
  #}
  tags {
    Name       = "${var.tag_name_prefix}VPC-Jump-default"
    Department = "${var.tag_department}"
    Author = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_subnet" "VPC_jump" {
  vpc_id                  = "${aws_vpc.Jump_VPC.id}"
  cidr_block              = "10.115.100.0/28"
  map_public_ip_on_launch = true

  #availability_zone = "us-east-1a"
  #availability_zone = "us-east-2a"
  tags {
    Name        = "${var.tag_name_prefix}Jump-subnet"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }

  depends_on = ["aws_internet_gateway.Jump_IGW"]
}

resource "aws_internet_gateway" "Jump_IGW" {
  vpc_id = "${aws_vpc.Jump_VPC.id}"

  tags {
    Name        = "${var.tag_name_prefix}Jump_IGW"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.Jump_VPC.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.Jump_IGW.id}"
}

### Assoc subnet with default route id ###
#resource "aws_route_table_association" "a" {
#  subnet_id      = "${aws_subnet.VPC_jump.id}"
#  route_table_id = "${aws_vpc.Jump_VPC.default_route_table_id}"
#}

// This is only here to ensure it gets named and tagged
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.Jump_VPC.id}"

  tags {
    Name        = "${var.tag_name_prefix}Jump_default"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description} AWS_Defaults"
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
}
resource "aws_security_group" "external_access" {
  name        = "${var.tag_name_prefix}external-access"
  description = "SSH and ICMP from anywhere"
  vpc_id      = "${aws_vpc.Jump_VPC.id}"

  tags {
    Name        = "${var.tag_name_prefix}external-access"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
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

resource "aws_network_interface" "jump-eth0" {
  subnet_id         = "${aws_subnet.VPC_jump.id}"
  security_groups   = ["${aws_security_group.external_access.id}"]
  source_dest_check = false
  private_ips       = ["10.115.100.10"]

  tags {
    Name        = "${var.tag_name_prefix}jump_host-eth0"
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

  key_name = "${var.keypair_name}"

  tags {
    Name        = "${var.tag_name_prefix}jump_host"
    Department  = "${var.tag_department}"
    Author      = "${var.tag_author}"
    Environment = "${var.tag_environment}"
    Autostop    = "${var.tag_autostop}"
    Description = "${var.tag_description}"
  }

  #provisioner "remote-exec" {
  #  inline = [
  #    "echo '10.115.100.10	jump.localdomain jump' >> /etc/hosts",
  #    "hostname jump"
  #    #"ip route add 10.2.12.0/24 via 10.2.11.6"
  #    #"ip route replace default via 10.2.11.6"
  #  ]
  #}
}

output "vpc_id" {
  value = "${aws_vpc.VPC.id}"
}

#output "cidr_block" {
#  value = "${aws_vpc.VPC.cidr_block}"
#}

output "downstream_cidr_block" {
  value = "${aws_subnet.downstream.cidr_block}"
}

output "upstream_cidr_block" {
  value = "${aws_subnet.upstream.cidr_block}"
}

output "main_route_table_id" {
  value = "${aws_vpc.VPC.main_route_table_id}"
}

output "host_id" {
  value = "${aws_instance.jump.id}"
}

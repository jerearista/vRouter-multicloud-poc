output "public_ip" {
  value = "${aws_instance.jump.public_ip}"
}

output "host_id" {
  value = "${aws_instance.jump.id}"
}

output "vpc_id" {
  value = "${aws_vpc.Jump_VPC.id}"
}

output "cidr_block" {
  value = "${aws_vpc.Jump_VPC.cidr_block}"
}

output "main_route_table_id" {
  value = "${aws_vpc.Jump_VPC.main_route_table_id}"
}

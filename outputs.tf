output "discovered_instance_vRouter_id" {
  value = "${data.aws_ami.vRouter.id}"
}

output "discovered_instance_vRouter_name" {
  value = "${data.aws_ami.vRouter.name}"
}

output "discovered_instance_amazon_linux_id" {
  value = "${data.aws_ami.amazon_linux.id}"
}

output "discovered_instance_amazon_linux_name" {
  value = "${data.aws_ami.amazon_linux.name}"
}

output "discovered_instance_windows_id" {
  value = "${data.aws_ami.windows.id}"
}

output "discovered_instance_windows_name" {
  value = "${data.aws_ami.windows.name}"
}

output "jump-host_public_ip" {
  value = "${module.jump.public_ip}"
}

#output "host_id" {
#  value = "${aws_instance.jump.id}"
#}


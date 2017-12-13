# #####
# # Copy this file to my.tfvars, edit the desired values, then use the
# # commands, below, to run terraform.  See README.md for more.
# #####
#
# terraform plan \
#  -var 'access_key=foo' \
#  -var 'secret_key=bar'
#
# terraform plan \
#  -var-file="secret.tfvars" \
#  -var-file="production.tfvars"
#
#  Single-shot:
#  terraform apply -var-file=my.tfvars
#
#  Review plan, then ensure that is exactly what is executed:
#  terraform plan -var-file=my.tfvars -out=myplan
#  terraform apply myplan
#
#  Remove environment:
#  terraform destroy -var-file=my.tfvars

# N. VA
#aws_region = "us-east-1"
# Ohio
aws_region = "us-east-2"
# N. CA
#aws_region = "us-west-1"
# Oregon
#aws_region = "us-west-2"
# London
#aws_region = "eu-west-2"

tag_name_prefix = "my-poc-"
tag_department = "My Dept"
tag_author = "me"
tag_environment = "sandbox"
tag_autostop = "no"
tag_description = "POC for a purpose"

keypair_name = "${var.tag_name_prefix}key"
#key_path = "~/.ssh/id_rsa_cloud_poc.pub"
public_key = "ssh-rsa AAA...7R9 cloud_poc_key"

aws_instance_type = "m4.large"

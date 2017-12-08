# vRouter Automation Demo

## Overview

## Setup your environment

* Install AWS CLI
**  * Configure credentials
    `aws configure`
* Download and install Terraform in your PATH
* Change to the demo directory (here)
  `cd demo`
* Ensure the AWS provider plugin is installed
  ` terraform init`
* Check the cvp.tfvars settings
* Get modules
  `terraform get`

## Deploy the environment

```
`terraform validate -var-file="cvp.tfvars" base_env/`

`terraform plan -var-file="cvp.tfvars" -out=plan
`terraform apply "plan”`
```

## Copy your private key to the jump-host

```
scp -rp ~/.ssh/id_rsa* ec2-user@<jump_host_ip>:.ssh/
```

## Teardown the environment

```
terraform destroy -var-file="cvp.tfvars"
```
## Mark a specific resource to be rebuilt

To mark the vRouter in VPC 112 to be requilt, mark it as tainted, then run apply:

```
terraform taint -module=VPC-112 aws_instance.vRouter
terraform apply -var-file="cvp.tfvars"
```

# vRouter Automation Demo

## Overview

## Setup your environment

* Install AWS CLI
  * Configure credentials  
   `aws configure`
* Download and install Terraform in your PATH
* Change to the poc directory (here)  
  `cd vRouter-multicloud-poc`
* Ensure the AWS and template provider plugins are installed  
  ` terraform init`
* Copy the `sample.tfvars` file to `my.tfvars` and update the values  
   `cp sample.tfvars my.tfvars`
* Get modules  
  `terraform get`

## Deploy the environment

```
terraform validate -var-file="my.tfvars"

terraform plan -var-file="my.tfvars" -out=plan
terraform apply "plan”
```

## Teardown the environment

```
terraform destroy -var-file="my.tfvars"
```
## Mark a specific resource to be rebuilt

To mark the vRouter in VPC 112 to be rebuilt, mark it as tainted, then run apply:

```
terraform taint -module=VPC-112 aws_instance.vRouter
terraform apply -var-file="my.tfvars"
```

## Contributing

Please validate and format file prior to committing:

```
terraform validate -var-file="my.tfvars"
terraform fmt
git add <...>
```

## Archive files

```
export REPO_DIR=`pwd`; (cd .. && tar czvf vRouter-terraform-4-vpc-topo.tgz --exclude='archive' --exclude='terraform.*' --exclude='.terraform*' --exclude='.git' $REPO_DIR)
```

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

## Setup prerequisites

```
`terraform validate -var-file="cvp.tfvars" base_env/`

`terraform plan -var-file="cvp.tfvars" -out=plan base_env/`
`terraform apply "plan”`
```

## Teardown the environment

```
terraform destroy -var-file="cvp.tfvars" base_env/
```

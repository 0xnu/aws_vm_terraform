# AWS VM Terraform

A [Terraform](https://en.wikipedia.org/wiki/Terraform_(software)) configuration to provision an [Alpine Linux](https://alpinelinux.org/) image into [AWS EC2](https://aws.amazon.com/ec2/).

## Prerequisites

* Have an AWS account - [Free Tier](https://aws.amazon.com/us/free/)
* An access key in [AWS IAM](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) with enough permissions to create resources
* [AWS S3](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html) bucket `{project}-terraform-state-files`
* Terraform cli `>= 0.12.20`
* Public/private ssh key pair

## Steps

### 1. Clone the repository
```bash
git clone git@github.com:0xnu/aws_vm_terraform.git
cd aws_vm_terraform
```

### 2. Set environment vars and `{repo}/config/vars.tfvars`

Windows Console:
***
```
setx AWS_DEFAULT_REGION "{region}"
setx AWS_ACCESS_KEY_ID "{aws_key}"
setx AWS_SECRET_ACCESS_KEY "{aws_secret}"
```
> **Note**: values won't be visible in current prompt. Re-open terminal for this.

Linux/Mac Terminal:
***
```bash
export AWS_DEFAULT_REGION="{region}"
export AWS_ACCES_KEY_ID="{aws_key}"
export AWS_SECRET_ACCESS_KEY="{aws_secret}"
```

### 3. Add your private ssh key into `{repo}/config/private-key`

### 4. Init the backend
```bash
terraform init
```

### 5. Show the plan
```bash
terraform plan -var-file=config/vars.tfvars
```

### 6. Build the infra with apply
```bash
terraform apply -var-file=config/vars.tfvars
```

## Description

Terraform will create 5 resources:

* `aws_key_pair`: _key pair to access via ssh to instance._
* `aws_eip.eip`: _A public elastic ip address._
* `aws_security_group`: _Security group with firewall access definition._
* `aws_instance`: _The instance._
* `aws_eip_association`: _Association between instance and the Elastic IP._

Current state of plan will be stored into S3 bucket previously created

Files:

* `variables.tf`: _contains the initialization of empty variables required._
* `config/vars.tfvars`: _the values of the vars defined._
* `backend.tf`: _the terraform client and backend configuration for state files._
* `provider.tf`: _contains the config of aws plugin to handle amazon resources._
* `network.tf`: _contains network resources._
* `nginx.tf`: _contains all definitions to create the instance and provision config._
* `.gitignore`: _contains definitions to avoid pushing credentials or terraform files._
* `output.tf`: _contains the vars output defs to shown after apply._
* `config`: _folder contains the configuration and keys._
* `config/bootstrap/content`: _for custom website, add and replace your own files in here._

## Test and Verify

* Visit IP address in your default browser: `http://{elastic_ip}`

* SSH: connect to terminal

```bash
ssh -i {yourprivatekey} alpine@{elastic_ip}
```

## How to Uninstall

Destroy the resources with a single terraform command
```bash
terraform destroy -var-file=config/vars.tfvars
```

## Authors

- **Finbarrs Oketunji** _aka 0xnu_ - _Main Developer_ - [0xnu](https://github.com/0xnu)

## License

This project is licensed under the [WTFPL License](LICENSE) - see the file for details.

## Copyright

(c) 2020 [Finbarrs Oketunji](https://finbarrs.eu).


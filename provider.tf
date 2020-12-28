# Configure the aws provider
provider "aws" {
  version = "~> 2.57"
  # Following vars are omitted as we are using ENV vars.
  /*
    region = var.region_vm
    access_key = var.aws_key
    secret_key = var.aws_secret
  */
}

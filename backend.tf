# Backend configuration
terraform {
  # Minimal version for terraform cli
  required_version = ">= 0.12.20"
  # Set the terraform state fie remotely in S3
  backend "s3" {
    bucket = "octopodami-terraform-state-files"
    key    = "terraform-aws-vm.tfstate"
  }
}

terraform {
  backend "s3" {
    bucket       = "fase3-bucket-terraform"
    key          = "fase3-terraform/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

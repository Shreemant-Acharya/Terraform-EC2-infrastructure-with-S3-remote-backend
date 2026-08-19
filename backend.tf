terraform {
  backend "s3" {
    bucket       = "shreemant-tf-ec2-tfstate"
    key          = "ec2/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}
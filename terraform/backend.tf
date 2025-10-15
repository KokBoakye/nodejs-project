terraform {
  backend "s3" {
    bucket = "nodejs-terraform-state-15-10-2025"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
  }
}

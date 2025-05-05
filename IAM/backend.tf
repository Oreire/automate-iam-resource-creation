terraform {
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "iam-user/terraform.tfstate"
    region = "eu-west-2"
  }
}

terraform {
 backend "s3" {
    bucket = "an-cloud"
    key    = "tera/terraform.tfstate"
    region = "eu-north-1"
  }
}



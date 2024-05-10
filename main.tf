provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "key" {
  key_name = "terraform-key"
  public_key = file("aws-key.pub")
}
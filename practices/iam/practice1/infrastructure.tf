resource "aws_s3_bucket" "test_bucket" {
  bucket        = "my-test-bucket-adfer-e0801584-3523-4c42-8116-7052bff29d2a"
  region        = var.configurable_region
  force_destroy = true
}

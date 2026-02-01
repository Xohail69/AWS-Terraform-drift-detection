resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    "ManualChange" = "True"
    "SohailChange" = "Yes"
  }
}
resource "aws_s3_bucket" "imported_bucket" {
  bucket = "my-manual-bucket-jio"

  tags = {
    "existingbucket" = "yes"
  }
}
# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "my-legacy-bucket-02-import"
resource "aws_s3_bucket" "legacy_bucket_2" {
  bucket              = "my-legacy-bucket-02-import"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags                = {}
  tags_all            = {}
}

# __generated__ by Terraform from "my-legacy-bucket-01-import"
resource "aws_s3_bucket" "legacy_bucket_1" {
  bucket              = "my-legacy-bucket-01-import"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags                = {}
  tags_all            = {}
}

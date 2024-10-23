resource "aws_s3_bucket" "terraform_state" {
    bucket = "${var.project}-tf-state-bucket"
    force_destroy = true
}


resource "aws_s3_bucket_ownership_controls" "bucket_ownership_ctr" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "terraform_bucket_acl" {
    depends_on = [ aws_s3_bucket_ownership_controls.bucket_ownership_ctr ]
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


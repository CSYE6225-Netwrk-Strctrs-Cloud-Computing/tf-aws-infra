
resource "random_uuid" "s3_bucket_uuid" {}

locals {
  formatted_bucket_tag_name = replace(lower(var.bucket_tag_name), " ", "-")
}


resource "aws_s3_bucket" "aws_s3_bucket" {

  bucket        = "${random_uuid.s3_bucket_uuid.result}-${local.formatted_bucket_tag_name}"
  force_destroy = true

  tags = {
    Name = "${local.formatted_bucket_tag_name}-s3-bucket"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle_config" {
  bucket = aws_s3_bucket.aws_s3_bucket.id

  rule {
    id = "lifecycle"
    filter {}

    transition {
      days          = var.transition_days
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_key_encryption" {
  bucket = aws_s3_bucket.aws_s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.aws_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


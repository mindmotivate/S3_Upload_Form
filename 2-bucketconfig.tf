# S3 bucket for static website.
resource "aws_s3_bucket" "s3_upload_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
  force_destroy = true
}

/*
# Configures the S3 bucket to host a static website with specified index and error documents.
resource "aws_s3_bucket_website_configuration" "s3_upload_website" {
  bucket = aws_s3_bucket.s3_upload_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
*/

# Blocks public access to the S3 bucket to prevent unauthorized access and enforce security.
resource "aws_s3_bucket_public_access_block" "s3_upload_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_upload_bucket.bucket
  block_public_acls       = false  # Prevents adding objects to buckets
  block_public_policy     = false  # Bucket rejects policies that allow public access
  ignore_public_acls     = false  # If public access is granted by an ACL, it will be ignored
  restrict_public_buckets = false  # Only AWS principals and authorized users can access bucket
}

# S3 bucket policy allowing access to certain actions for specific AWS services
resource "aws_s3_bucket_policy" "s3_upload_bucket_policy" {
  bucket = aws_s3_bucket.s3_upload_bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:ListBucket",
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

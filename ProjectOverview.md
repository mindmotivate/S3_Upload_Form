## Module 1: S3 Bucket for Website
This module sets up an S3 bucket named "passportint" to host a website. It's tagged with metadata to identify it as part of the development environment.

```
resource "aws_s3_bucket" "passportint" {
  bucket = "passportint"

  tags = {
    Name        = "passportint"
    Environment = "Development"
  }
}
```

## Module 2: S3 Bucket Website Configuration
This module configures the "passportint" S3 bucket for website hosting. It specifies the default index document as "index.html" and the error document as "error.html".

```
resource "aws_s3_bucket_website_configuration" "passportint_website" {
  bucket = aws_s3_bucket.passportint.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

## Module 3: S3 Public Access Block
This module ensures that public access is blocked for the "passportint" S3 bucket. It sets up configurations to prevent public ACLs, public policies, and restricts access to only authorized AWS principals.

```
resource "aws_s3_bucket_public_access_block" "passportint_access_block" {
  bucket = aws_s3_bucket.passportint.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

## Module 4: S3 Server-Side Encryption
This module enables server-side encryption for the "passportint" S3 bucket using AES256. It ensures that data stored in the bucket is encrypted at rest.

```
resource "aws_s3_bucket_server_side_encryption_configuration" "passportint_encryption_config" {
  bucket = aws_s3_bucket.passportint.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

## Module 5: S3 Versioning
This module enables versioning for the "passportint" S3 bucket. Versioning helps protect objects from accidental deletion or modification by maintaining multiple versions of each object.

```
resource "aws_s3_bucket_versioning" "passportint_versioning" {
  bucket = aws_s3_bucket.passportint.bucket

  versioning_configuration {
    status = "Enabled"
  }
}
```

## Module 6: Upload Website Content to S3
This module uploads the website's HTML and image files to the "passportint" S3 bucket. It ensures that the specified files are available for hosting on the website.

```
resource "aws_s3_object" "content" {
  depends_on = [aws_s3_bucket.passportint]

  bucket                  = aws_s3_bucket.passportint.bucket
  key                     = "index.html"
  source                  = "./index.html"
  server_side_encryption = "AES256"
  content_type           = "text/html"
}

resource "aws_s3_object" "international_women" {
  depends_on = [aws_s3_bucket.passportint]

  bucket                  = aws_s3_bucket.passportint.bucket
  key                     = "internationalwomen.gif"
  source                  = "./internationalwomen.gif"
  server_side_encryption = "AES256"
  content_type           = "image/gif"
}
```

## Module 7: CloudFront Origin Access Control
This module configures origin access control for CloudFront. It defines settings related to how CloudFront accesses the S3 bucket origin.

```
resource "aws_cloudfront_origin_access_control" "site_access" {
  name                              = "security_cf_s3_oac_passportint"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
```

## Module 8: CloudFront Distribution
This module creates a CloudFront distribution for the website. It specifies settings such as the S3 origin, cache behavior, access restrictions, and viewer certificate.

```
resource "aws_cloudfront_distribution" "site_access" {

  origin {
    domain_name = aws_s3_bucket.www-ipgame2_bucket.bucket_regional_domain_name
    origin_id   = "s3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.OAI.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # viewer_protocol_policy = "https-only"
    viewer_protocol_policy = "redirect-to-https"
    # viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ssl_support_method = "sni-only"
    acm_certificate_arn = data.aws_acm_certificate.issued.arn
    minimum_protocol_version = "TLSv1.2_2021"
  }

aliases = ["malgusclan.com", "www.malgusclan.com"]  # Add your custom domain aliases here


depends_on = [aws_cloudfront_origin_access_identity.OAI]
}

```

## Module 9: S3 Bucket Policy for CloudFront Origin Access Identity (OAI)
This module sets up a bucket policy allowing access to objects in the S3 bucket by a CloudFront Origin Access Identity (OAI). It relies on an IAM policy document to define the permissions and a bucket policy resource to apply those permissions to the S3 bucket.

```
resource "aws_s3_bucket_policy" "OAI_policy" {
  bucket = aws_s3_bucket.www-ipgame2_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json

  depends_on = [aws_cloudfront_distribution.site_access]
}
```

## Module 10: IAM Policy Document for S3 Bucket
This module creates an IAM policy document specifying the permissions required for the CloudFront Origin Access Identity (OAI) to access objects in the S3 bucket. It allows the OAI to perform the "s3:GetObject" action on objects within the bucket.

```
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.www-ipgame2_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.OAI.iam_arn]
    }
  }
}
```

## Module 11: Outputs
This module provides outputs including the CloudFront URL and a clickable CloudFront URL for easy access to the website.

```
output "cloudfront_url" {
  value       = aws_cloudfront_distribution.site_access.domain_name
  description = "CloudFront domain name"
}

output "cloudfront_url_link" {
  value       = format("https://%s", aws_cloudfront_distribution.site_access.domain_name)
  description = "Clickable CloudFront URL"
}

output "cloudfront_custom_domain" {
  value       = aws_route53_record.site-domain.fqdn
  description = "Custom domain name"
}

output "cloudfront_custom_domain_link" {
  value = format("https://%s", aws_route53_record.site-domain.fqdn)
  description = "Clickable CloudFront URL"
}
```
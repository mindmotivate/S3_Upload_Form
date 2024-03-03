# S3 Bucket creation

hcl
```
resource "aws_s3_bucket" "s3_upload_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
  force_destroy = true
}
```

# Blocks public access to the S3 bucket to prevent unauthorized access and enforce security

hcl
```
resource "aws_s3_bucket_public_access_block" "s3_upload_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_upload_bucket.bucket
  block_public_acls       = false  # Prevents adding objects to buckets
  block_public_policy     = false  # Bucket rejects policies that allow public access
  ignore_public_acls     = false  # If public access is granted by an ACL, it will be ignored
  restrict_public_buckets = false  # Only AWS principals and authorized users can access bucket
}
```

# S3 bucket policy allowing access to certain actions for specific AWS services

hcl
```
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
```




# SNS topic for notifications.

hcl
```
resource "aws_sns_topic" "topic" {
  name = "s3-bucket-notifications"
}
```


# SNS topic policy allowing S3 to publish messages and allowing subscription

hcl
```
resource "aws_sns_topic_policy" "bucket_to_topic" {
  arn = aws_sns_topic.topic.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowS3ToPublishMessages"
        Effect    = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.topic.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.s3_upload_bucket.arn
          }
        }
      },
      {
        Sid       = "AllowSubscriptions"
        Effect    = "Allow"
        Principal = {
          AWS = "*"
        }
        Action    = "sns:Subscribe"
        Resource  = aws_sns_topic.topic.arn
      }
    ]
  })

  depends_on = [aws_sns_topic.topic]
}

# Subscribe an email address to the SNS topic
#resource "aws_sns_topic_subscription" "email_subscription" {
#  topic_arn = aws_sns_topic.topic.arn
#  protocol  = "email"
#  endpoint  = "example@gmail.com"
#}
```



# Subscribe email addresses to the SNS topic

hcl
```
resource "aws_sns_topic_subscription" "email_subscriptions" {
  count     = length(var.email_addresses)
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email_addresses[count.index]
}


output "email_addresses_output" {
  value = "Emails will be sent to the following email addresses ${join(", ", var.email_addresses)}"
}
```

# S3 bucket notification to SNS topic.

hcl
```
resource "aws_s3_bucket_notification" "s3_notif" {
  bucket = aws_s3_bucket.s3_upload_bucket.id

  topic {
    topic_arn = aws_sns_topic.topic.arn
    events    = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]  # Including object deletion event
  }
}
```




# Variables used

hcl
```
variable "bucket_name" {
  type    = string
  default = "ipgame2bucket"
}



variable "email_addresses" {
  type    = list(string)
  default = [""]
}


/* optional map version
variable "bucket_name" {
  type = map(string)
  default = {}
}
*/

```


# .tfvars file to store your email list

hcl
```
email_addresses = [
    "example1@email.com",
    "example2@email.com",
    "example3@email.com",
    "example4@email.com",
    "example5@email.com",
  
]
```




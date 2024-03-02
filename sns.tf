# SNS topic for notifications.
resource "aws_sns_topic" "topic" {
  name = "s3-bucket-notifications"
}

# SNS topic policy allowing S3 to publish messages and allowing subscription
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


# Subscribe email addresses to the SNS topic
resource "aws_sns_topic_subscription" "email_subscriptions" {
  count     = length(var.email_addresses)
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email_addresses[count.index]
}


output "email_addresses_output" {
  value = "Emails will be sent to the following email addresses ${join(", ", var.email_addresses)}"
}


# S3 bucket notification to SNS topic.
resource "aws_s3_bucket_notification" "s3_notif" {
  bucket = aws_s3_bucket.s3_upload_bucket.id

  topic {
    topic_arn = aws_sns_topic.topic.arn
    events    = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]  # Including object deletion event
  }
}


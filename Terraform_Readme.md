# Terraform Modules Used:

- **SNS Topic Creation**:
  - Creates an SNS topic named "s3-bucket-notifications".

- **SNS Topic Policy**:
  - Defines a policy allowing S3 to publish messages to the topic and allowing subscriptions to the topic.
  - Specifies conditions for allowing S3 to publish messages.

- **Email Subscriptions**:
  - Subscribes email addresses specified in a variable (`var.email_addresses`) to the SNS topic for receiving notifications.
  - Uses a loop to subscribe multiple email addresses.

- **Output**:
  - Outputs a message indicating the email addresses to which notifications will be sent.

- **S3 Bucket Notification to SNS Topic**:
  - Configures the S3 bucket to send notifications to the SNS topic.
  - Defines events that trigger notifications, including object creation and removal, and includes an object deletion event.


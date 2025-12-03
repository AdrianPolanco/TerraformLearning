resource "aws_iam_user" "employee_user" {
  name = var.employee_name
}

resource "aws_iam_group" "auditors_group" {
  name = var.group_name
}

resource "aws_iam_group_membership" "group_membership" {
  name  = "${var.group_name}_membership"
  group = aws_iam_group.auditors_group.name
  users = [aws_iam_user.employee_user.name]
}

resource "aws_s3_bucket" "test_bucket" {
  bucket        = "my-test-bucket-adfer-e0801584-3523-4c42-8116-7052bff29d2a"
  region        = var.configurable_region
  force_destroy = true
}

resource "aws_iam_policy" "s3_readonly" {
  name        = "s3_readonly_policy"
  description = "IAM policy to provide read-only access to S3 buckets"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject"]
        # ${aws_s3_bucket.test_bucket.arn}/* for s3:GetObject
        Resource = ["${aws_s3_bucket.test_bucket.arn}/*"]
      },
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        # aws_s3_bucket.test_bucket.arn for s3:ListBucket
        Resource = [aws_s3_bucket.test_bucket.arn]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
        Resource = ["arn:aws:s3:::*"]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  group      = aws_iam_group.auditors_group.name
  policy_arn = aws_iam_policy.s3_readonly.arn
}

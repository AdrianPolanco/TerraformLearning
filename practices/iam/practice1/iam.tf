resource "aws_iam_user" "employee_user" {
  name = var.employee_name
}

resource "aws_iam_group" "auditors_group" {
  name = var.group_name
}

resource "aws_iam_user_group_membership" "group_membership" {
  groups = [aws_iam_group.auditors_group.name]
  user   = aws_iam_user.employee_user.name
}

/*resource "aws_iam_policy" "s3_readonly" {
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
      }
    ]
  })
}*/

data "aws_iam_policy" "s3_readonly_managed" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  group      = aws_iam_group.auditors_group.name
  policy_arn = data.aws_iam_policy.s3_readonly_managed.arn
}

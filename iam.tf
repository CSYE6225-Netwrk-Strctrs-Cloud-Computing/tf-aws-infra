# iam.tf
resource "aws_iam_role" "ec2_role" {
  name = "EC2-CSYE6225"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "iam_policy_s3_access" {
  name        = "WebAppS3"
  description = "Provides permission to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObject",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.aws_s3_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.aws_s3_bucket.id}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "policy_role_attach_s3" {
  name       = "policy_role_attach"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.iam_policy_s3_access.arn
}

data "aws_iam_policy" "cloudwatch_policy" {
  name = "CloudWatchAgentServerPolicy"
}

resource "aws_iam_policy_attachment" "policy_role_attach_cloudwatch" {
  name       = "policy_role_attach_cloudwatch"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = data.aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_iam_instance_profile" "ec2_role_profile" {
  name = "ec2_role_profile"
  role = aws_iam_role.ec2_role.name
}

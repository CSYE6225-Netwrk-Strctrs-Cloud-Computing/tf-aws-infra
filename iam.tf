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

resource "aws_autoscaling_policy" "scale_up" {
  name                    = "scale_up"
  policy_type             = "SimpleScaling"
  autoscaling_group_name  = aws_autoscaling_group.app_asg.name
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Average"
}

resource "aws_autoscaling_policy" "scale_down" {
  name                    = "scale_down"
  policy_type             = "SimpleScaling"
  autoscaling_group_name  = aws_autoscaling_group.app_asg.name
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Average"
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"
  threshold           = "5"
  alarm_description   = "This alarm fires when CPU utilization is greater than 5%"
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  treat_missing_data  = "notBreaching"
  threshold           = "3"
  alarm_description   = "This alarm fires when CPU utilization is less than 3%"
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
}
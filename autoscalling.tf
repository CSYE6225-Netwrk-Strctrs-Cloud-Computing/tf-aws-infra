resource "aws_autoscaling_group" "app_asg" {
  name = "app_asg"

  launch_template {
    id      = aws_launch_template.csye6225_asg.id
    version = "$Latest"
  }

  min_size         = 3
  max_size         = 5
  desired_capacity = 3
  vpc_zone_identifier = aws_subnet.aws_tanuj_public_subnets[*].id


  tag {
    key                 = "Name"
    value               = "app-instance"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 60
  target_group_arns         = [aws_lb_target_group.lb.arn]

  lifecycle {
    create_before_destroy = true
  }
}

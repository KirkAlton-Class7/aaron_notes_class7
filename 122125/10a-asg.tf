resource "aws_autoscaling_group" "web_tier" {
  vpc_zone_identifier = [aws_subnet.private_a.id,
    aws_subnet.private_b.id,
  aws_subnet.private_c.id]

  max_size = 6
  min_size = 3

  default_cooldown          = 60
  default_instance_warmup   = 60
  health_check_grace_period = 120
  health_check_type         = "ELB"

  force_delete              = true
  wait_for_capacity_timeout = 0

  target_group_arns = [aws_lb_target_group.web_tier.arn]

  launch_template {
    id      = aws_launch_template.web_tier.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-app"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}
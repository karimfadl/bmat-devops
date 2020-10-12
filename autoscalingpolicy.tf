# scale up alarm

resource "aws_autoscaling_policy" "sqs-policy-scaleup" {
  name                   = "sqs-policy-scaleup"
  autoscaling_group_name = aws_autoscaling_group.example-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "queue-depth-alarm-scaleup" {
 alarm_name          = "queue-depth-alarm-scaleup"
 comparison_operator = "GreaterThanOrEqualToThreshold"
 evaluation_periods  = "1"
 metric_name         = "ApproximateNumberOfMessagesVisible"
 namespace           = "AWS/SQS"
 period              = "60"
 statistic           = "Average"
 threshold           = "4"
 treat_missing_data = "notBreaching"

 dimensions = {
 AutoScalingGroupName = aws_autoscaling_group.example-autoscaling.name
 }

 actions_enabled = true
 alarm_actions   = [aws_autoscaling_policy.sqs-policy-scaleup.arn]
}

# scale down alarm

resource "aws_autoscaling_policy" "sqs-policy-scaledown" {
  name                   = "sqs-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.example-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "queue-depth-alarm-scaledown" {
 alarm_name          = "queue-depth-alarm-scaledown"
 comparison_operator = "LessThanOrEqualToThreshold"
 evaluation_periods  = "1"
 metric_name         = "ApproximateNumberOfMessagesVisible"
 namespace           = "AWS/SQS"
 period              = "60"
 statistic           = "Average"
 threshold           = "4"
 treat_missing_data = "notBreaching"

 dimensions = {
 AutoScalingGroupName = aws_autoscaling_group.example-autoscaling.name
 }

 actions_enabled = true
 alarm_actions   = [aws_autoscaling_policy.sqs-policy-scaledown.arn]
}

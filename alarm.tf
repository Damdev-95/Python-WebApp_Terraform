resource "aws_cloudwatch_metric_alarm" "App_Alarm" {
  alarm_name          = "PythonAPP_Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Too requests on Application"
  treat_missing_data  = "notBreaching"
  alarm_actions       = ["${aws_sns_topic.sns_topic.arn}"]
  ok_actions          = ["${aws_sns_topic.sns_topic.arn}"]
  dimensions = {
    LoadBalancer = aws_lb.web-elb.arn_suffix
  }
}

# SNS Topic for RequestCount
resource "aws_sns_topic" "sns_topic" {
  name = "PythonAPP-sns_topic"
}

resource "aws_sns_topic_policy" "notify_policy" {
  arn    = aws_sns_topic.sns_topic.arn
  policy = data.aws_iam_policy_document.notify_policy.json
}

data "aws_iam_policy_document" "notify_policy" {
  statement {
    actions = [
      "SNS:Publish",
    ]

    resources = [
      "${aws_sns_topic.sns_topic.arn}",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }
}
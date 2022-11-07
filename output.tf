output "security_group" {
  value = aws_security_group.webserver-sg.id
}

output "launch_configuration" {
  value = aws_launch_configuration.web-lc.id
}

output "asg_name" {
  value = aws_autoscaling_group.web-asg.id
}

output "elb_name" {
  value = aws_lb.web-elb.dns_name
}
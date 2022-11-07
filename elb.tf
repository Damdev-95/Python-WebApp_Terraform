locals {
  availability_zones = split(",", var.availability_zones)
}

# Create ALB
resource "aws_lb" "web-elb" {
   name              = "PythonAPP-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups  = [aws_security_group.elb-sg.id]
  subnets          =[aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]     
  tags = {
        name  = "WebApp-AppLoadBalancer"
       }
}

# Create ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-elb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_lb_target_group" "web-tg" {
  name     = "WebApp-Target-Group"
  # depends_on = [aws_vpc.PythonAPP]
  depends_on = [aws_lb.web-elb]
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.PythonAPP.id
  health_check {
    interval            = 70
    path                = "/"
    port                = 8000
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60 
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_web" {
  autoscaling_group_name = aws_autoscaling_group.web-asg.id
  lb_target_group_arn    = aws_lb_target_group.web-tg.arn
}


# resource "aws_lb_target_group_attachment" "web-app" {
#   target_group_arn = aws_lb_target_group.web-tg.arn
#   target_id        = aws_autoscaling_group.web-asg.id
#   port             = 200
# }

resource "aws_autoscaling_group" "web-asg" {
  name                 = "PythonAPP-asg"
  max_size             = var.asg_max
  min_size             = var.asg_min
  desired_capacity     = var.asg_desired
  force_delete         = true
  depends_on         = [aws_lb.web-elb]
  health_check_type  = "EC2"
  launch_configuration = aws_launch_configuration.web-lc.name
  # load_balancers       = [aws_elb.web-elb.name]
  vpc_zone_identifier = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
  
  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = "true"
  }
}

resource "aws_launch_configuration" "web-lc" {
  name          = "PythonAPP-lc"
  image_id      = var.ami
  instance_type = var.instance_type


  security_groups = [aws_security_group.webserver-sg.id]
  user_data       = filebase64("${path.module}/userdata.sh")
  key_name        = var.keypair
}
resource "aws_lb" "app_alb" {
  name                 = "app-alb"
  internal             = false
  load_balancer_type   = "application"
  security_groups      = [aws_security_group.alb_access.id]
  subnets              = [for subnet in aws_subnet.app_public_subnets : subnet.id]
  preserve_host_header = true
  idle_timeout         = 300


  tags = {
    Name = "app-alb"
  }
}

resource "aws_lb_target_group" "app_ec2_tg" {
  name     = "app-ec2-instances"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id

  health_check {
    healthy_threshold   = 5
    matcher             = "200-301"
    interval            = 30
    path                = "/"
    unhealthy_threshold = 3
  }

  depends_on = [
    aws_autoscaling_group.app_autoscaling_group
  ]
}



resource "aws_lb_listener" "https_app" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = data.aws_acm_certificate.app_amazon_issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_ec2_tg.arn
  }
}

resource "aws_lb_listener" "http_https_redirect" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
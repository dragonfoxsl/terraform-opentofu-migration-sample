resource "aws_autoscaling_group" "app_autoscaling_group" {
  name                = "app_ec2_autoscaling_group"
  vpc_zone_identifier = [for subnet in aws_subnet.app_public_subnets : subnet.id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2

  launch_template {
    id      = aws_launch_template.app_server_tempalte.id
    version = aws_launch_template.app_server_tempalte.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}

resource "aws_autoscaling_attachment" "app_ec2_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.app_ec2_tg.arn
}
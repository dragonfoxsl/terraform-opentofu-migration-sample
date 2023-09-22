resource "aws_launch_template" "app_server_tempalte" {
  name                                 = "app-web-server"
  disable_api_stop                     = true
  disable_api_termination              = true
  image_id                             = data.aws_ami.ubuntu.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t3a.medium"
  key_name                             = var.ec2_instance_key
  user_data                            = filebase64("${path.module}/nginx_install.sh")

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      delete_on_termination = true
      volume_type           = "gp3"
      volume_size           = 20
      encrypted             = true
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }

  credit_specification {
    cpu_credits = "standard"
  }




  iam_instance_profile {
    arn = aws_iam_instance_profile.app_instance_profile.arn
  }



  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.app_server_access.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "[app]nginx-server"
    }
  }


}
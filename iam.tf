resource "aws_iam_role" "app_instance_role" {
  name               = "ec2AppSSMRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.app_instance_assume_role.json

  tags = {
    Name = "aws-ec2-app-ssm-role"
  }
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "ec2AppSSMRole"
  role = aws_iam_role.app_instance_role.name
}

resource "aws_iam_role_policy_attachment" "aws_managed_ssm_core_policy" {
  role       = aws_iam_role.app_instance_role.name
  policy_arn = data.aws_iam_policy.ssm_core.arn
}
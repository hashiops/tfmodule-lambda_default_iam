data "aws_iam_policy_document" "logs-full-access" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

data "aws_iam_policy_document" "vpc-access" {
  statement {
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

/*
NOTE: This assume_role_policy is very similar but slightly different than
just a standard IAM policy and cannot use an aws_iam_policy resource. It can
however, use an aws_iam_policy_document data source, see example below for how
this could work.

https://www.terraform.io/docs/providers/aws/r/iam_role.html
*/
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.environment}_iam_for_lambda_${var.application_name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_for_lambda_logs" {
  name = "logs-full-access"
  role = "${aws_iam_role.iam_for_lambda.id}"
  policy = "${data.aws_iam_policy_document.logs-full-access.json}"
}

resource "aws_iam_role_policy" "iam_for_lambda_vpc" {
  name = "vpc-access"
  role = "${aws_iam_role.iam_for_lambda.id}"
  policy = "${data.aws_iam_policy_document.vpc-access.json}"
}

output "lambda_role_arn" {
  value = "${aws_iam_role.iam_for_lambda.arn}"
}

output "lambda_role_id" {
  value = "${aws_iam_role.iam_for_lambda.id}"
}

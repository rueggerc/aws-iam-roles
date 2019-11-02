output "ruegger_execution_role_arn" {
    value = "${aws_iam_role.ruegger_lambda_execution_role.arn}"
}
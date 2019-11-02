output "rueggerllc_execution_role_arn" {
    value = "${aws_iam_role.lambda_execution_role.arn}"
}

output "rueggerllc_api_gateway_lambda_invoke_role_arn" {
    value = "${aws_iam_role.api_gateway_lambda_invoke_role.arn}"
}
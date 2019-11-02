
##################################
# Account
##################################
data "aws_caller_identity" "current_account" {
}

##################################
# Roles
##################################
resource "aws_iam_role" "ruegger_lambda_execution_role" {
  name = "ruegger_lambda_execution_role"
  assume_role_policy = "${file("policies/lambda-role.json")}"
}

// CloudWatch Policy
resource "aws_iam_policy" "cloudwatch-policy" {
  name   = "cloudwatch-logs-policy"
  policy = "${file("policies/cloudwatch-policy.json")}"
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach-role" {
  role       = "${aws_iam_role.ruegger_lambda_execution_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch-policy.arn}"
}
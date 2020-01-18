provider "aws" {
    region = "${var.region}"
}

terraform {
    backend "s3" {
        bucket = "rueggerllc-terraform-state"
        key = "aws-iam-roles/us-east-1/dev/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "rueggerllc-terraform-locks"
        encrypt = true
    }
}
data "aws_caller_identity" "current_account" {
}

##################################
# Roles
##################################
resource "aws_iam_role" "lambda_execution_role" {
  name = "ruegger_lambda_execution_role"
  force_detach_policies = true
  assume_role_policy = "${file("policies/lambda-role.json")}"
}

resource "aws_iam_role" "api_gateway_lambda_invoke_role" {
  name = "ruegger_api_gateway_lambda_invoke_role"
  force_detach_policies = true
  assume_role_policy = "${file("policies/lambda-role.json")}"
}

// CloudWatch Policy
resource "aws_iam_policy" "cloudwatch_policy" {
  name   = "ruegger_cloudwatch_logs_policy"
  policy = "${file("policies/cloudwatch-policy.json")}"
}

// Lambda Invocation Policy
resource "aws_iam_role_policy" "invocation_policy" {
  name = "ruegger_invoke_lambda_policy"
  role = "${aws_iam_role.api_gateway_lambda_invoke_role.id}"
  policy = "${file("policies/invoke-lambda-policy.json")}"
}

// SQS Policy
resource "aws_iam_role_policy" "sqs_policy" {
  name = "ruegger_invoke_lambda_policy"
  role = "${ruegger_sqs_policy}"
  policy = "${file("policies/sqs-policy.json")}"
}


# Attach Policies to Roles
resource "aws_iam_role_policy_attachment" "attach_role" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach_role" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "${aws_iam_policy.sqs_policy.arn}"
}

resource "aws_iam_role_policy_attachment" "attach_role-lambda-invoke" {
  role       = "${aws_iam_role.api_gateway_lambda_invoke_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_policy.arn}"
}
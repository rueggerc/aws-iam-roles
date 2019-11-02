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

// CloudWatch Policy
resource "aws_iam_policy" "cloudwatch_policy" {
  name   = "ruegger_cloudwatch_logs_policy"
  policy = "${file("policies/cloudwatch-policy.json")}"
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach_role" {
  role       = "${aws_iam_role.lambda_execution_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_policy.arn}"
}
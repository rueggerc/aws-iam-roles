terraform {
    backend "s3" {
        bucket = "rueggerllc-terraform-state"
        key = "aws-iam-roles/us-east-1/dev/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "rueggerllc-terraform-locks"
        encrypt = true
    }
}
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 3.5.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-west-2"
# }

# resource "aws_budgets_budget" "uhh" {
#   name              = "monthly-budget"
#   budget_type       = "COST"
#   limit_amount      = "50.0"
#   limit_unit        = "USD"
#   time_unit         = "MONTHLY"
#   time_period_start = "2024-02-26_00:01"
# }
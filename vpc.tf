


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.38.0"
  # insert the 12 required variables here

  name = "test-db-vpc"

  cidr = "20.0.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets  = ["20.0.1.0/24", "20.0.2.0/24"]
  database_subnets = ["20.0.11.0/24", "20.0.12.0/24"]
  public_subnets   = ["20.0.21.0/24", "20.0.22.0/24"]

  create_database_subnet_group = true
  
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC flow logs (cloudwatch log group and IAM role with be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  tags = {
    Owner = "user"
    Environment = "staging"
  }

}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"
  # insert the 2 required variables here
}
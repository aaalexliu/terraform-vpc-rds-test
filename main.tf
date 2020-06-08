
provider "aws" {
  region = var.region
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.38.0"
  # insert the 12 required variables here

  name = var.vpc_name

  cidr = var.vpc_cidr

  azs              = var.vpc_azs
  private_subnets  = var.vpc_private_subnets
  database_subnets = var.vpc_database_subnets
  public_subnets   = var.vpc_public_subnets

  create_database_subnet_group = true
  
  enable_nat_gateway = true
  single_nat_gateway = true

  # VPC endpoint for S3
  enable_s3_endpoint = true

  # VPC flow logs (cloudwatch log group and IAM role with be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  tags = var.vpc_tags
}

data "aws_security_group" "default" {
  name = "default"
  vpc_id = module.vpc.vpc_id
}

module "ping_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.10.0"
  # insert the 2 required variables here

  name = "Allow ping access"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port = 8
      to_port = 0
      protocol = "icmp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "postgresql_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/postgresql"
  version = "~> 3.0"

  name = "computed-postgres-sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  computed_ingress_with_source_security_group_id = [
    {
        rule = "postgresql-tcp"
        source_security_group_id = data.aws_security_group.default.id
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
}

# module "rds" {
#   source  = "terraform-aws-modules/rds/aws"
#   version = "2.15.0"
#   # insert the 11 required variables here
# }
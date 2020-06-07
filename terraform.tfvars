region = "us-east-1"

vpc_name             = "test-db-vpc"
vpc_cidr             = "20.0.0.0/16"
vpc_azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
vpc_private_subnets  = ["20.0.1.0/24", "20.0.2.0/24"]
vpc_database_subnets = ["20.0.11.0/24", "20.0.12.0/24"]
vpc_public_subnets   = ["20.0.21.0/24", "20.0.22.0/24"]
vpc_tags             = {
  Owner       = "user"
  Environment = "staging"
}
terraform {
  backend "s3" {
    bucket = "mfour-infra-state"
    key    = "dev/terraform.tfstate"
    region = "us-west-2"
  }
}

module "rds" {
  source = "../../modules/rds"

  #These are database specific attributes. 
  multi_az                     = false
  cluster_identifier           = "aurora-cluster-test-db"
  database_engine              = "aurora"
  database_engine_version      = "5.6.mysql_aurora.1.22.5"
  database_instance_class      = "db.r5.large"
  database_instance_identifier = "sotg-dev-database"
  security_group_id            = "sg-19419966"
  snapshot_identifier          = "sotg-2021-08-23"

  # These are variables outputted from the VPC Module.  
  vpc_id              = "vpc-9d436afb"
  private_subnet_1    = "subnet-16ecaf70"
  private_subnet_2    = "subnet-c6a1328e"
}
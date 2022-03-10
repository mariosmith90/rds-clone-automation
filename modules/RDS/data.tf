data "aws_security_group" "vpc-all-dev" {
  id = var.security_group_id
}


data "aws_db_cluster_snapshot" "latest_prod_snapshot" {
  db_cluster_identifier = var.snapshot_identifier
  most_recent           = true
}

data "aws_vpc" "vpc_dev" {
  id = var.vpc_id
}

data "aws_subnet" "private-subnet_1" {
  id = var.private_subnet_1
}

data "aws_subnet" "private_subnet_2" {
  id = var.private_subnet_2
}

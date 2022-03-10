resource "aws_db_subnet_group" "database-subnet-group" {
  name        = "database subnets"
  subnet_ids  = [var.private_subnet_1, var.private_subnet_2]
  description = "Subnets for Database Instance"

  tags = {
    Name = "database subnets"
  }
}

resource "aws_rds_cluster_instance" "cluster-instance" {
  availability_zone    = "us-west-2a"
  instance_class       = var.database_instance_class
  engine_version       = var.database_engine_version
  engine               = var.database_engine
  cluster_identifier   = aws_rds_cluster.aws-dev-cluster.id
  db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
}

# resource "null_resource" "setup_db" {
#   depends_on = [ aws_rds_cluster_instance.cluster-instance ]
#   triggers = {
#     file_sha = "${sha1(file("../../modules/RDS/scripts/script.sql"))}"
#   }
#   provisioner "local-exec" {
#     command = "mysql -h ${aws_rds_cluster.aws-dev-cluster.endpoint}  -u ${aws_rds_cluster.aws-dev-cluster.master_username} -p ${aws_rds_cluster.aws-dev-cluster.master_password} < ../../modules/RDS/scripts/script.sql"
#   }
# }

# This is where the database password is generated. 
resource "random_password" "database_password" {
  length  = 16
  special = false
}

resource "aws_rds_cluster" "aws-dev-cluster" {
  skip_final_snapshot       = true
  apply_immediately         = true
  database_name             = "sotgdev"
  final_snapshot_identifier = "delete-db"

  snapshot_identifier    = data.aws_db_cluster_snapshot.latest_prod_snapshot.id
  cluster_identifier     = var.cluster_identifier
  master_username        = var.database_username
  master_password        = random_password.database_password.result
  vpc_security_group_ids = [data.aws_security_group.vpc-all-dev.id]
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
}
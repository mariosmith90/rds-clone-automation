output "database_username" {
    value = aws_rds_cluster.aws-dev-cluster.master_username
}

output "database_password" {
    value = aws_rds_cluster.aws-dev-cluster.master_password
}

output "database_endpoint" {
    value = aws_rds_cluster.aws-dev-cluster.endpoint
}

output "database_name" {
    value = aws_rds_cluster.aws-dev-cluster.database_name
}
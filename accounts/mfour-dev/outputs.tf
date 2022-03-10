output "database_username" {
    value = module.rds.database_username
}

output "database_password" {
    value = module.rds.database_password
    sensitive = false
}

output "database_endpoint" {
    value = module.rds.database_endpoint
}

output "database_name" {
    value = module.rds.database_name
}
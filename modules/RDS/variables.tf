
variable "cluster_identifier" {
  type = string
}

variable "database_engine" {
  type = string
}

variable "database_instance_class" {
  type = string
}

variable "database_engine_version" {
  type = string
}

variable "database_instance_identifier" {
  type = string
}

variable "database_username" {
  type    = string
  default = "root"
}

variable "snapshot_identifier" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "security_group_id" {
  type = string
}

variable "vpc_id" {
  type    = string
}

variable "private_subnet_1" {
  type = string
}

variable "private_subnet_2" {
  type = string
}


variable "access_key" { default = "" }

variable "secret_key" {	default = "" }

variable "region" { }

variable "security_group" { type = map }

variable "subnet" { }

variable "cidr_block" { type = string }

variable "amis" { type = map }

variable "vpc_id" { type = map }

variable "key_pair_name" { type = map }

variable "s3_bucket_name" { type = map }

variable "db_name" { type = string }

variable "postgres_user" { type = string }

variable "postgres_pwd" { type = string }
variable "db_name" {
  description = "name for RDS postgres sql db"
  type        = string
  default     = "kanduladb"
}

variable "db_secret_name" {
  description = "identifying name for db secrets in secretsmanager"
  type        = string
  default     = "kanduladblihi"
}

variable "db_storage" {
  description = "size of db in gb"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "engine and version for rds db"
  type        = map(string)
  default = {
    engine  = "postgres"
    version = "12.9"
  }
}

variable "db_instance" {
  description = "instance type to be used for db instances"
  type        = string
  default     = "db.t2.micro"
}

variable "db_port" {
  description = "port for db connections"
  type        = number
  default     = 5432
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for public subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "private_subnet_id"{}
variable "my_vpc_id" {}
variable "source_security_group_id_common" {}
variable "source_security_group_id_kube" {}


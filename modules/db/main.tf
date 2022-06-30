data "aws_secretsmanager_secret" "kandula_db" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "kandula_db" {
  secret_id = data.aws_secretsmanager_secret.kandula_db.id
}


locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.kandula_db.secret_string)
}

resource "aws_db_instance" "kandula_db" {
  allocated_storage      = var.db_storage
  engine                 = var.db_engine["engine"]
  identifier             = var.db_name
  engine_version         = var.db_engine["version"]
  instance_class         = var.db_instance
  port                   = var.db_port
  name                   = var.db_name
  username               = local.db_credentials["username"]
  password               = local.db_credentials["password"]
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.kandula_db.name
   tags ={
     name  = "rds_server"
     consul_join = var.consul_join_tag_value
     consul      = "agent"
     monitor = "node_exporter"
   }
}

resource "aws_db_subnet_group" "kandula_db" {
  name       = "db-sn-grp"
  subnet_ids = var.private_subnet_id

  tags = {
    Name = format("db-sn-grp")
  }
}
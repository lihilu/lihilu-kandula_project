output "db_endpoint" {
    value = aws_db_instance.kandula_db.endpoint 
}

output "db_admin" {
    value = aws_db_instance.kandula_db.username
}

output "db_pass" {
    value = aws_db_instance.kandula_db.password
}

output "db_host" {
  value = "${split(":",aws_db_instance.kandula_db.endpoint )[0]}"
  description = "db host name"
}

output "db_name" {
  value = var.db_name
  description = "db name"
}

output "db_sg_id"{
  value = aws_security_group.rds_sg.id
}
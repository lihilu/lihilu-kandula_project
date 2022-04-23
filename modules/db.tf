
// Configure the EC2 instance in a private subnet
resource "aws_instance" "ec2_db" {
  ami                         = data.aws_ami.ubuntu.id
  count                       = var.num_db_server
  associate_public_ip_address = false
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private[count.index].id
  vpc_security_group_ids      = [aws_security_group.DB_instnaces_access.id]
  tags = {
    "Name" = "DB - ${count.index}"
    "purpose"             = var.purpose_tag
  }

}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
variable "ubuntu_account_number" {
  default = "099720109477"
}


# Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2_web" {
  ami                         = data.aws_ami.ubuntu.id
  count                       = var.num_web_server
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.web_admin.name
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [aws_security_group.common_sg.id]
 # user_data                   = file("${path.module}${var.user_data_web}")

  tags = {
    "Name" = "WEB - ${count.index}"
    "purpose"             = var.purpose_tag
  }
  
    # root disk
  root_block_device {
    volume_size           = "30"
    volume_type           = var.volume_type
    encrypted             = false
  }
  #data disk
    ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    encrypted             = true
  }
}

#Key pair (login)
resource "aws_key_pair" "deployer" {
  key_name = "terraform-ec2-key"
  public_key = file("terraform-ec2-key.pub")
}

#VPC
resource "aws_default_vpc" "default" {
  
}

#Security group (to open ports)
resource "aws_security_group" "terra_sg_group" {
  name = "terra-sg"
  description = "This will add a TF generated Security Group"
  vpc_id = aws_default_vpc.default.id

#Inbound Rules
ingress {
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

ingress {
  from_port = 3000
  to_port = 3000
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

#Outbound Rules
egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "all outbound access"
}
}

#Ec2 Instance
resource "aws_instance" "my_instance" {
  key_name = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [ aws_security_group.terra_sg_group.id ]
  instance_type = "t3.micro"
  ami = "ami-0aba19e56f3eaec05"


root_block_device{
  volume_size = 15
  volume_type = "gp3"
}

tags = {
  name = "terra-ec2"
}
}
variable "name"       { type = string }
variable "vpc_id"     { type = string }
variable "subnet_id"  { type = string }
variable "public_key" { type = string }
variable "my_ip_cidr" { type = string }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
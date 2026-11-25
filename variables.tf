variable "env"           { type = string }
variable "vpc_cidr"      { type = string }
variable "public_cidrs"  { type = list(string) }
variable "private_cidrs" { type = list(string) }
variable "my_ip_cidr"    { type = string }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "db_username" {
  type    = string
  default = "admin"
}
variable "db_password" {
  type      = string
  sensitive = true
}
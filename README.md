# Terraform EC2 Infrastructure with S3 Remote Backend

Creates an AWS EC2 server with Terraform and keeps the Terraform state safely in S3, for people learning Infrastructure as Code on AWS.

## Features

- Creates an EC2 instance with a security group and SSH key pair in the default VPC
- Stores Terraform state in an S3 bucket instead of on your laptop
- Bucket has versioning, encryption and all public access blocked
- State locking turned on (`use_lockfile`)
- A separate `bootstrap/` folder creates the bucket first

## Tech stack

Terraform, AWS (EC2, VPC, S3)

## Run it locally

You need Terraform, the AWS CLI, Git and an AWS account.

```bash
aws configure
aws sts get-caller-identity

git clone https://github.com/Shreemant-Acharya/Terraform-EC2-infrastructure-with-S3-remote-backend.git
cd Terraform-EC2-infrastructure-with-S3-remote-backend

# 1. Create the S3 bucket for state
cd bootstrap
terraform init
terraform apply
cd ..

# 2. Create the EC2 server
terraform init
terraform plan
terraform apply

# 3. Remove everything when done (the S3 bucket stays)
terraform destroy
```

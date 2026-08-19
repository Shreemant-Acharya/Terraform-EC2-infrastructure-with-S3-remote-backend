# 🏗️ Terraform AWS EC2 Infrastructure

A **Terraform-based AWS infrastructure project** that provisions an EC2 environment and manages Terraform state remotely using an **Amazon S3 backend**.

This project demonstrates **Infrastructure as Code (IaC)**, remote state management, state locking, S3 security configuration, and reusable AWS provisioning workflows.

---

## 📌 Features

- ☁️ AWS infrastructure provisioned using Terraform
- 🖥️ EC2 instance deployment
- 🌐 Default VPC integration
- 🔐 Custom security group
- 🔑 SSH key pair configuration
- 🪣 S3 remote backend for Terraform state
- 🔄 S3 bucket versioning enabled
- 🔒 Server-side encryption enabled
- 🚫 Public access completely blocked
- 🔐 Terraform native state locking using S3 lock files
- 🏗️ Separate bootstrap configuration for backend provisioning
- 🛡️ Sensitive Terraform state and SSH keys excluded from Git

---

## 🏗️ Architecture

```text
                         Developer
                             |
                             |
                        Terraform CLI
                             |
              +--------------+--------------+
              |                             |
              |                             |
              v                             v
        AWS Infrastructure             S3 Backend
              |                             |
              |                             |
        +-----+------+                terraform.tfstate
        |            |                       |
        v            v                +------+------+
   Default VPC   Security Group       |             |
        |                             v             v
        |                         Versioning    Encryption
        v
   EC2 Instance
        |
        v
    SSH Access
```

---

## 📂 Project Structure

```text
Terraform-Ec2/
|
|-- bootstrap/
|   |-- main.tf
|   `-- .terraform.lock.hcl
|
|-- Ec2.tf
|-- terraform.tf
|-- backend.tf
|-- .terraform.lock.hcl
|-- .gitignore
`-- README.md
```

### ⚙️ Main Terraform Configuration

The root Terraform configuration provisions the AWS infrastructure.

### 🪣 Bootstrap Configuration

The `bootstrap/` directory is a separate Terraform configuration used to create the S3 bucket required for Terraform remote state.

This is necessary because Terraform cannot use an S3 backend before that S3 bucket exists.

---

## ☁️ AWS Resources

The project currently manages the following AWS resources:

- 🌐 Default VPC
- 🖥️ EC2 instance
- 🔐 Security group
- 🔑 EC2 key pair
- 🪣 S3 bucket for Terraform state

---

## 🗄️ Remote State Management

Terraform state is stored remotely in **Amazon S3** instead of relying only on a local `terraform.tfstate` file.

The backend is configured in `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket       = "shreemant-tf-ec2-tfstate"
    key          = "ec2/terraform.tfstate"
    region       = "eu-north-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

Remote state provides several advantages:

- 📦 Centralized Terraform state
- 🛡️ Better protection against local state loss
- 🔐 State locking to prevent concurrent Terraform operations
- 👥 Easier collaboration
- ♻️ State recovery using S3 versioning

---

# 🔐 S3 Backend Security

The backend bucket is configured using Terraform with multiple security and reliability features.

## 🔄 Versioning

S3 versioning keeps previous versions of the Terraform state file.

This helps recover the infrastructure state if the latest state is accidentally overwritten or corrupted.

---

## 🔒 Server-Side Encryption

Terraform state objects are encrypted using **AES-256 server-side encryption**.

```hcl
sse_algorithm = "AES256"
```

This protects Terraform state while it is stored inside Amazon S3.

---

## 🚫 Public Access Blocking

Public access to the Terraform state bucket is completely blocked using:

```hcl
block_public_acls       = true
block_public_policy     = true
ignore_public_acls      = true
restrict_public_buckets = true
```

Terraform state can contain sensitive infrastructure information, so it should never be publicly accessible.

---

# 🛠️ Prerequisites

Before running the project, install:

- 🏗️ Terraform
- ☁️ AWS CLI
- 🧑‍💻 Git
- 🔑 An AWS account

Configure AWS credentials:

```bash
aws configure
```

Verify authentication:

```bash
aws sts get-caller-identity
```

---

# 🚀 Deployment

## 1️⃣ Clone the Repository

```bash
git clone https://github.com/Shreemant-Acharya/Terraform-EC2-infrastructure-with-S3-remote-backend.git
```

Navigate into the project directory:

```bash
cd terraform-aws-infrastructure
```

---

## 2️⃣ Create the Terraform Backend

Enter the bootstrap directory:

```bash
cd bootstrap
```

Initialize Terraform:

```bash
terraform init
```

Preview the backend infrastructure:

```bash
terraform plan
```

Create the S3 backend:

```bash
terraform apply
```

Return to the main project:

```bash
cd ..
```

---

## 3️⃣ Initialize the Main Infrastructure

```bash
terraform init
```

Terraform will initialize the AWS provider and connect to the configured **S3 remote backend**.

---

## 4️⃣ Validate the Configuration

```bash
terraform validate
```

Terraform checks the configuration files for syntax and configuration errors.

---

## 5️⃣ Format Terraform Files

```bash
terraform fmt -recursive
```

This keeps the Terraform configuration consistently formatted.

---

## 6️⃣ Preview Infrastructure Changes

```bash
terraform plan
```

Terraform displays the resources that will be:

```text
+ Created
~ Modified
- Destroyed
```

before making any changes to AWS.

---

## 7️⃣ Deploy the Infrastructure

```bash
terraform apply
```

Confirm with:

```text
yes
```

Terraform will provision the configured AWS infrastructure.

---

# 🔎 Checking Terraform State

View resources currently tracked by Terraform:

```bash
terraform state list
```

Inspect the current remote state:

```bash
terraform state pull
```

Verify that the state exists in S3:

```bash
aws s3 ls s3://shreemant-tf-ec2-tfstate --recursive
```

The remote state is stored at:

```text
s3://shreemant-tf-ec2-tfstate/ec2/terraform.tfstate
```

---

# 🔄 Terraform State Flow

```text
Terraform Configuration
          │
          ▼
    terraform apply
          │
          ├─────────────────────────┐
          │                         │
          ▼                         ▼
   AWS Infrastructure          S3 Backend
          │                         │
          │                         ▼
          │                  terraform.tfstate
          │                         │
          │                ┌────────┴────────┐
          │                │                 │
          │                ▼                 ▼
          │            Versioning        Encryption
          │
          ▼
     EC2 Instance
```

---

# 🧹 Destroying the Infrastructure

To avoid unnecessary AWS charges when the environment is not required:

```bash
terraform destroy
```

Terraform will remove the provisioned EC2 infrastructure while the S3 backend can remain available for future deployments.

The infrastructure can later be recreated using:

```bash
terraform plan
terraform apply
```

---

# 🔐 Git Security

Terraform state files, SSH private keys, Terraform working directories, and other sensitive files are excluded through `.gitignore`.

Examples:

```gitignore
.terraform/

*.tfstate
*.tfstate.*
*.tfplan

*.tfvars
*.tfvars.json

*.pem
*.key
terraform-ec2-key
terraform-ec2-key.pub

*.zip

current-state.json
```

The Terraform provider lock file is intentionally committed:

```text
.terraform.lock.hcl
```

This helps maintain consistent provider versions across deployments.

---

# 🔁 Terraform Workflow

```text
Write Infrastructure Code
          │
          ▼
    terraform init
          │
          ▼
   terraform validate
          │
          ▼
     terraform plan
          │
          ▼
     terraform apply
          │
          ▼
    AWS Infrastructure
          │
          └────────────────────┐
                               │
                               ▼
                       S3 Remote State
```

---

# 🎯 What I Learned

Through this project, I practiced:

- 🏗️ Infrastructure as Code using Terraform
- 🖥️ AWS EC2 provisioning
- 🌐 AWS networking and security groups
- 🗄️ Terraform state management
- ☁️ Migrating local Terraform state to an S3 backend
- 🔐 Terraform state locking
- 🔄 S3 versioning
- 🔒 S3 encryption
- 🛡️ Securing Terraform state
- ♻️ Managing infrastructure lifecycle with `plan`, `apply`, and `destroy`
- 📂 Structuring Terraform backend bootstrapping separately from application infrastructure
- 🔑 Safely storing Terraform projects in GitHub

---

# 👨‍💻 Author

**Shreemant Acharya**

DevOps / Cloud Engineering Portfolio Project

---

# ⭐ Project Summary

> Provisioned AWS EC2 infrastructure using Terraform with a secure Amazon S3 remote backend for centralized state management. The project implements state locking, S3 versioning, AES-256 encryption, public access blocking, security groups, SSH key management, and a separate bootstrap configuration for backend provisioning.

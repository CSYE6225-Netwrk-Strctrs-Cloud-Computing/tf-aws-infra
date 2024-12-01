# AWS Networking Setup Using Terraform

This repository contains Terraform configurations to set up an AWS networking environment with a VPC, subnets, route tables, an Internet Gateway, and associated resources.

---

## Prerequisites

1. **Install Terraform**  
   Ensure Terraform is installed on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).

2. **AWS CLI Installed and Configured**  
   Install the AWS CLI and configure it with your credentials:
   ```bash
   aws configure
   ```
   Alternatively, set the AWS credentials as environment variables:
   ```bash
   export AWS_ACCESS_KEY_ID=your_access_key
   export AWS_SECRET_ACCESS_KEY=your_secret_key
   export AWS_DEFAULT_REGION=your_region
   ```

3. **Git Installed**  
   Ensure Git is installed to clone the repository.

---

## Configuring Variables

To manage variables for the Terraform configuration, create a `terraform.tfvars` file in the project directory.

---

## Steps to Deploy the Infrastructure

### 1. Clone the Repository
Clone the repository to your local machine:
```bash
git clone https://github.com/your_username/your_repository.git
cd your_repository
```

### 2. Initialize Terraform
Run the following command to initialize the Terraform configuration:
```bash
terraform init
```

### 3. Plan the Deployment
To see the changes that Terraform will make, execute:
```bash
terraform plan
```

### 4. Apply the Configuration
To deploy the VPC and associated resources, run:
```bash
terraform apply
```
Confirm with `yes` when prompted.

### 5. Verify the Setup
After the `apply` command completes, verify the resources in the AWS Management Console.

---

## Importing an ACM Certificate

If your setup requires an ACM certificate, you can import it using the following command:
```bash
aws acm import-certificate \
  --certificate fileb://~/Desktop/demo_cloud04.me/demo_cloud04_me.crt \
  --certificate-chain fileb://~/Desktop/demo_cloud04.me/demo_cloud04_me.ca-bundle \
  --private-key fileb://~/Desktop/demo_cloud04.me/demo.cloud04.me.key
```

Replace the paths to the certificate files with the appropriate paths on your local machine.

---

## Cleaning Up Resources

To remove all the resources created by Terraform, run:
```bash
terraform destroy
```
Confirm with `yes` when prompted.

---

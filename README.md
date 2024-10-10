# tf-aws-infra

## Running the Terraform Configuration

To deploy the AWS networking setup using Terraform, follow these steps:

1. **Install Terraform**:
   - Ensure you have Terraform installed on your local machine. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).

2. **Configure AWS Credentials**:
   - Make sure your AWS credentials are configured. You can set them up in the `~/.aws/credentials` file or export them as environment variables:
  
     export AWS_ACCESS_KEY_ID=your_access_key
     export AWS_SECRET_ACCESS_KEY=your_secret_key
     export AWS_DEFAULT_REGION=your_region
     
3. **Clone the Repository**:
   - Clone your repository to your local machine:
    
     git clone https://github.com/your_username/your_repository.git
     cd your_repository

4. **Initialize Terraform**:
   - Run the following command to initialize the Terraform configuration:
     
     terraform init

5. **Plan the Deployment**:
   - To see what changes will be made by Terraform, run:
    
     terraform plan

6. **Apply the Configuration**:
   - To create the VPC and associated resources, run:
     terraform apply
     
7. **Verify the Setup**:
   - After the apply command completes, you can verify the resources created in the AWS Management Console.

8. **Clean Up**:
   - If you want to remove all the resources created by Terraform, run:
     terraform destroy
     
 

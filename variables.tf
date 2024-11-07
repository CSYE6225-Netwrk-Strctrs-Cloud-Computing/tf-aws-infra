variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "number_of_public_subnets" {
  description = "Number of public subnets to create"
  type        = number
}

variable "number_of_private_subnets" {
  description = "Number of private subnets to create"
  type        = number
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "application_port" {
  description = "The port on which the application runs."
  type        = number
  default     = 8080
}

variable "key_pair_name" {
  description = "Name of the key pair to use for EC2 instance SSH access."
  type        = string
}

variable "custom_ami" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
  default     = "t2.micro"
}

variable "db_master_password" {
  description = "The master password for the database."
  type        = string
  sensitive   = true
}

variable "DB_NAME" {
  description = "The name of the database to create."
  type        = string
}

variable "DB_IDENTIFIER" {
  description = "The identifier for the DB instance."
  type        = string
}

variable "DB_USERNAME" {
  description = "The username for the database."
  type        = string
}

variable "DB_PASSWORD" {
  description = "The password for the database."
  type        = string
  sensitive   = true
}

variable "bucket_tag_name" {
  description = "The tag name for the S3 bucket."
  type        = string
  default     = "Private Bucket"
}

variable "expiration_days" {
  description = "Number of days after which objects in the bucket expire."
  type        = number
  default     = 365
}

variable "transition_days" {
  description = "Number of days after which objects transition to STANDARD_IA."
  type        = number
  default     = 30
}

variable "domain_name" {
  description = "The domain name for the Route 53 record."
  type        = string
}

variable "record_type" {
  description = "The type of DNS record."
  type        = string
}

variable "ttl_value" {
  description = "TTL value for the DNS record."
  type        = number
}

variable "zone_id" {
  description = "The ID of the Route 53 hosted zone."
  type        = string
}

variable "subdomain_type" {
  description = "Type of subdomain to create (dev or demo)."
  type        = string
}

variable "port" {
  description = "port number of database"
  type        = number
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID for S3 access"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key for S3 access"
  type        = string
}

variable "cpu_lowthreshold" {
  description = "The threshold for CPU utilization in percentage"
  type        = number
  default     = 3
}

variable "cpu_highthreshold" {
  description = "The threshold for CPU utilization in percentage (for high CPU alarm)"
  type        = number
  default     = 5
}

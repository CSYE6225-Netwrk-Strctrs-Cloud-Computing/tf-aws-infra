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
  default     = 8080 // Update the default value as necessary
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
  default     = "t2.micro" // Default instance type
}

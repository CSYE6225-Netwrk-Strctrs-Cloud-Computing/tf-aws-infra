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

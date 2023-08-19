variable "region" {
  description = "The AWS region to create resources in"
  default     = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the web subnet"
  default     = "10.0.1.0/24"
}

variable "db_subnet_cidr_block" {
  description = "The CIDR block for the db subnet"
  default     = "10.0.2.0/24"
}

variable "execution_role_arn" {
  description = "The ARN of the existing IAM role for the ECS task"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

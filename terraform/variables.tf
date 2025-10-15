variable "instance_type" {
  description = "The type of instance to use for the EC2 instance."
  type        = string
  default     = "t3.micro"
}

variable "my_ip" {
  description = "Your IP address to allow SSH access."
  type        = string
  default     = "90.194.42.253/32"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"

}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance."
  type        = string
  default     = "nodejs"
}

variable "project_name" {
  description = "The name of the project for tagging resources."
  type        = string
  default     = "nodejss-app"

}

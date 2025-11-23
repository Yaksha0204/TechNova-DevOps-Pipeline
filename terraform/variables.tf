variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = ""
}

variable "allowed_cidr" {
  description = "CIDR allowed to SSH (your IP)"
  type        = string
  default     = "0.0.0.0/0"
}

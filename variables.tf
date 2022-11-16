variable "region" {
  type        = string
  description = "The AWS region to create things in."
}


variable "vpc_cidr" {
  type        = string
  description = "The VPC cidr block"
}


variable "availability_zones" {
  default     = "us-east-1a,us-east-1b"
  description = "List of availability zones"
}

variable "ami" {
  type        = string
  description = "AMI id for the launch template"

}


variable "instance_type" {
  type        = string
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min numbers of servers in ASG"
  default     = "2"
}

variable "asg_max" {
  description = "Max numbers of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired numbers of servers in ASG"
  default     = "2"
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "name" {
  type    = string
  default = "Python_APP"

}


variable "keypair" {
  type        = string
  description = "keypair for the ec2 instances"

}

variable "disk_size" {
  type        = string
  description = "Size of the block storage"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }

  required_version = "~>1.14.0"
}

provider "aws" {
  region = var.configurable_region
}

variable "configurable_region" {
  type        = string
  default     = "us-east-1"
  description = "This is the variable representing the region we will be working on."
  validation {
    condition     = var.configurable_region == "us-east-1" || var.configurable_region == "us-east-2" || var.configurable_region == "us-west-1" || var.configurable_region == "us-west-2"
    error_message = "The provided region must be in USA"
  }
}

variable "employee_name" {
  type        = string
  default     = "Pepito"
  description = "This is the variable representing the employee name."
  validation {
    condition     = length(var.employee_name) > 0
    error_message = "The employee name must have some characters"
  }
}

variable "group_name" {
  type        = string
  default     = "auditores_s3"
  description = "This variable represents the group name you want the user to associate with"
  validation {
    condition     = length(var.group_name) > 0
    error_message = "The group name must have some characters"
  }
}

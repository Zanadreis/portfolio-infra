variable "domain_name" {
  description = "domain_name.com"
  type = string
}

variable "api_domain_name" {
  description = "api_domain_name"
  type = string
}

variable "aws_region" {
  description = "Variável que indica a região onde os recursos vão ser criados na AWS"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Variável que indica a região onde os recursos vão ser criados na AWS"
  type        = string
  default     = "us-east"
}

variable "cert_arn" {
  description = "ACM Certificate ARN"
  type = string
}
variable "env_prefix" {
  type = string
}

variable "env_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

// route table用 LOOP処理

variable "public_subnet_cidrs" {
  type = map(map(string))
}

variable "public_subnet_alb_cidrs" {
   type = map(map(string))
 }

variable "private_subnet_cidrs" {
  type = map(map(string))
}

variable "public_subnet_nat_cidrs" {
  type = map(map(string))
}

/*
 variable "private_nat_cidrs" {
   type = map(map(string))
 }

 variable "public_alb_cidrs" {
   type = map(map(string))
 }

variable "aws_availability_zone" {
  type = list(string)
}
*/
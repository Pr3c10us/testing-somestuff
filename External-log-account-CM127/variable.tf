variable "log_group_name"{
  default = "account1-log"
  type = string 
}


variable "aws_region" {
  type = string
  default     = "us-east-1"
}

variable "accountid" {
  type = number
  default     = "22222222222"
}

variable "env" {
  description = "Env e.g dev,prod,stg"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
}

variable "instance_count" {
  description = "Instance count"
  type        = number
}

variable "instance_volume_size" {
  description = "Instance Volume size"
  type        = number
}

variable "aws_instance_os_distro" {
  description = "Defines the operating system image filter for selecting an appropriate AMI (e.g., Ubuntu 20.04)."
  type        = string
  default     = "ubuntu/images/hvm-ssd/*amd64*"
}

variable "aws_ami_owners" {
  description = "AMI OWNER"
  type        = string
  default     = "099720109477"
}



variable "public_key_path" {
  type        = string
  description = "Key Path"

}

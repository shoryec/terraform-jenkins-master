variable "aws_region" {
  description = "The aws region resources are created"
  default = "ap-southeast-2"
}

variable "keypair_name" {
  description = "Name of aws keypair, to be used in naming and tagging"
}

variable "hosted_zone_id" {
  description = "Id of the AWS Public Hosted Zone"
}

variable "jenkins_master_instance_config" {
  type = "map"
  description = "The configuration variables used in creating the jenkins master instance"
}

variable "master_max_size" {
  description = "The max number of jenkins masters required"
}

variable "master_min_size" {
  description = "The min number of jenkins masters required"
}

variable "master_desired_capacity" {
  description = "The desired number of jenkins masters required"
}

variable "bastion_sg_id" {
  description = "Security Group id of Bastion instance"
}

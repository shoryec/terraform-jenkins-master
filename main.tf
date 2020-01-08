terraform {
  backend "s3" {}
  required_version = "=0.11.14"
  required_providers {
    aws = "=2.43"
  }
}
provider "aws" {
  region  = "${var.aws_region}"
  profile = "personal"
}

data "aws_vpc" "test_jenkins_vpc" {
  filter = {
      name = "tag:Name"
      values = ["test-jenkins"]
  }
}
data "aws_subnet_ids" "test_jenkins_pub_subnets" {
  vpc_id = "${data.aws_vpc.test_jenkins_vpc.id}"  
  filter {
    name   = "tag:Name"
    values = ["test-jenkins-public-*"]
  }
}
data "aws_subnet_ids" "test_jenkins_priv_subnets" {
  vpc_id = "${data.aws_vpc.test_jenkins_vpc.id}" 
  filter {
    name   = "tag:Name"
    values = ["test-jenkins-private-*"]
  }
}

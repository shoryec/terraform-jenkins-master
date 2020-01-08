terragrunt = {
  remote_state {
    backend = "s3"
    config {
    bucket         = "test-jenkins-shorye"
    region         = "ap-southeast-2"
    key            = "jenkins-master/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
    profile        = "personal"
    }
  }
}

aws_region = "ap-southeast-2"
keypair_name = "test-jenkins"
hosted_zone_id = "Z1G6V4NYWUKXJY"
jenkins_master_instance_config = {
    ami                     = "ami-07cc15c3ba6f8e287"
    type                    = "t2.micro"
    root_volume_size        = "80"
    az                      = "ap-southeast-2a"
}
master_min_size = 1
master_max_size = 1
master_desired_capacity = 1
bastion_sg_id = "sg-0bdaa1a16a5a3031a"


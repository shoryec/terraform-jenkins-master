data "template_file" "test_jenkins_master_user_data" {
  template = "${file("scripts/master_config.sh.tpl")}"

  vars = {
    efs_hostname =  "${aws_efs_file_system.test_jenkins_efs.dns_name}"
  }
}

resource "aws_launch_configuration" "test_jenkins_master" {
  depends_on      = ["aws_efs_mount_target.test_jenkins_efs_mount_tgt"]
  image_id        = "${var.jenkins_master_instance_config["ami"]}"
  instance_type   = "${var.jenkins_master_instance_config["type"]}"
  key_name        = "${var.keypair_name}"
  security_groups = ["${aws_security_group.jenkins_master_sg.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.jenkins_master_instance_config["root_volume_size"]}"
  }

  lifecycle {
    create_before_destroy = true
  }
  
  user_data       = "${data.template_file.test_jenkins_master_user_data.rendered}"
}

resource "aws_autoscaling_group" "test_jenkins_asg" {
  depends_on           = ["aws_launch_configuration.test_jenkins_master"]
  name                 = "test_jenkins_asg"
  max_size             = "${var.master_max_size}"
  min_size             = "${var.master_min_size}"
  desired_capacity     = "${var.master_desired_capacity}"
  vpc_zone_identifier  = ["${data.aws_subnet_ids.test_jenkins_priv_subnets.ids}"]
  launch_configuration = "${aws_launch_configuration.test_jenkins_master.name}"
  health_check_type    = "EC2"
  target_group_arns    = ["${aws_lb_target_group.test_jenkins_lb_target_group.arn}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "jenkins_master"
    propagate_at_launch = true
  }

}
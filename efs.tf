resource "aws_efs_file_system" "test_jenkins_efs" {
  creation_token = "test-jenkins-efs"

  tags {
    Name        = "test-jenkins-efs"
  }
}

resource "aws_efs_mount_target" "test_jenkins_efs_mount_tgt" {
  count           = "${length(data.aws_subnet_ids.test_jenkins_priv_subnets.ids)}"
  file_system_id  = "${aws_efs_file_system.test_jenkins_efs.id}"
  subnet_id       = "${element(data.aws_subnet_ids.test_jenkins_priv_subnets.ids, count.index)}"
  security_groups = ["${aws_security_group.test_jenkins_efs.id}"]
}
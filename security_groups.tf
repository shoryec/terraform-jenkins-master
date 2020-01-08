resource "aws_security_group" "test_jenkis_alb_sg" {
  name        = "test_jenkins_alb_sg"
  description = "Allow traffic on HTTP"
  vpc_id      = "${data.aws_vpc.test_jenkins_vpc.id}"

  tags {
    Name   = "test_jenkins_alb_sg"
  }
}
resource "aws_security_group_rule" "test_jenkis_alb_sg_rule_1" {
    depends_on  = ["aws_security_group.test_jenkis_alb_sg"]
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_group_id = "${aws_security_group.test_jenkis_alb_sg.id}"
    cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "test_jenkis_alb_sg_rule_egress" {
    depends_on  = ["aws_security_group.test_jenkis_alb_sg"]
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_group_id = "${aws_security_group.test_jenkis_alb_sg.id}"
    cidr_blocks = ["0.0.0.0/0"]
}


resource "aws_security_group" "jenkins_master_sg" {
  name        = "jenkins_master_sg"
  description = "Enable traffic on 8080 and SSH from vpn"
  vpc_id      = "${data.aws_vpc.test_jenkins_vpc.id}"

  tags {
    Name   = "jenkins_master_sg"
  }
}
resource "aws_security_group_rule" "jenkins_master_sg_rule_1" {
    depends_on  = ["aws_security_group.jenkins_master_sg"]
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_group_id = "${aws_security_group.jenkins_master_sg.id}"
    source_security_group_id = "${var.bastion_sg_id}"
}
resource "aws_security_group_rule" "jenkins_master_sg_rule_2" {
    depends_on  = ["aws_security_group.jenkins_master_sg"]
    type        = "ingress"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_group_id = "${aws_security_group.jenkins_master_sg.id}"
    source_security_group_id = "${aws_security_group.test_jenkis_alb_sg.id}"
}
resource "aws_security_group_rule" "jenkins_master_sg_rule_3" {
    depends_on  = ["aws_security_group.jenkins_master_sg"]
    type        = "ingress"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_group_id = "${aws_security_group.jenkins_master_sg.id}"
    source_security_group_id = "${var.bastion_sg_id}"
}
resource "aws_security_group_rule" "jenkins_master_sg_rule_4" {
    depends_on  = ["aws_security_group.jenkins_master_sg"]
    type        = "ingress"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_group_id = "${aws_security_group.jenkins_master_sg.id}"
    source_security_group_id = "${aws_security_group.jenkins_slave_sg.id}"
}
resource "aws_security_group_rule" "jenkins_master_sg_rule_egress" {
    depends_on  = ["aws_security_group.jenkins_master_sg"]
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_group_id = "${aws_security_group.jenkins_master_sg.id}"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "test_jenkins_efs" {
  name        = "test-jenkins-efs"
  description = "EFS access controls"
  vpc_id      = "${data.aws_vpc.test_jenkins_vpc.id}"
  
  tags {
    Name   = "test-jenkins-efs"
  }
}
resource "aws_security_group_rule" "test_jenkins_efs_rule_1" {
    depends_on  = ["aws_security_group.test_jenkins_efs"]
    type        = "ingress"
    from_port   = 2049
    to_port     = 2049
    protocol    = "-1"
    security_group_id = "${aws_security_group.test_jenkins_efs.id}"
    source_security_group_id = "${aws_security_group.jenkins_master_sg.id}"
}
resource "aws_security_group_rule" "test_jenkins_efs_rule_egress" {
    depends_on  = ["aws_security_group.test_jenkins_efs"]
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_group_id = "${aws_security_group.test_jenkins_efs.id}"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "jenkins_slave_sg" {
  name        = "jenkins_slave_sg"
  description = "Enable traffic on 8080 and SSH from vpn"
  vpc_id      = "${data.aws_vpc.test_jenkins_vpc.id}"

  tags {
    Name   = "jenkins_slave_sg"
  }
}
resource "aws_security_group_rule" "jenkins_slave_sg_rule_1" {
    depends_on  = ["aws_security_group.jenkins_slave_sg"]
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_group_id = "${aws_security_group.jenkins_slave_sg.id}"
    source_security_group_id = "${var.bastion_sg_id}"
}
resource "aws_security_group_rule" "jenkins_slave_sg_rule_2" {
    depends_on  = ["aws_security_group.jenkins_slave_sg"]
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_group_id = "${aws_security_group.jenkins_slave_sg.id}"
    source_security_group_id = "${aws_security_group.jenkins_master_sg.id}"
}
resource "aws_security_group_rule" "jenkins_slave_sg_rule_egress" {
    depends_on  = ["aws_security_group.jenkins_slave_sg"]
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_group_id = "${aws_security_group.jenkins_slave_sg.id}"
    cidr_blocks = ["0.0.0.0/0"]
}
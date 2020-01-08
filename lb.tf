resource "aws_lb" "test_jenkins_lb" {
  name               = "external-lb-test-jenkins"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.test_jenkis_alb_sg.id}"]
  subnets            = ["${data.aws_subnet_ids.test_jenkins_pub_subnets.ids}"]

  enable_deletion_protection = false

  tags = {
    Name = "external-lb-test-jenkins"
  }
}

resource "aws_lb_target_group" "test_jenkins_lb_target_group" {
  name     = "ext-lb-test-jenkins-tgt-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.test_jenkins_vpc.id}"

  health_check = {
      enabled   = true
      interval  = 10
      path      = "/"
      port      = 8080
      protocol  = "HTTP"
      timeout   = 5
      healthy_threshold = 5
      unhealthy_threshold = 5
      matcher   = 403
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = "${aws_lb.test_jenkins_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.test_jenkins_lb_target_group.arn}"
  }
}
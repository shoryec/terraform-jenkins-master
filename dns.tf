resource "aws_route53_record" "jenkins_master" {
  zone_id = "${var.hosted_zone_id}"
  name    = "test"
  type    = "A"

  alias {
    name                   = "${aws_lb.test_jenkins_lb.dns_name}"
    zone_id                = "${aws_lb.test_jenkins_lb.zone_id}"
    evaluate_target_health = true
  }
}

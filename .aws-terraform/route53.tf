data "aws_route53_zone" "mydomain_com" {
  name = "nature-sounds01.com"
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "nature-sounds01.com"
  validation_method = "DNS"

  tags = {
    Name = "acm-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  depends_on = ["aws_acm_certificate.cert"]
  name    = "${tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name}"
  type    = "${tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type}"
  zone_id = "${data.aws_route53_zone.mydomain_com.zone_id}"
  records = ["${tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.validation.fqdn}"]
}

resource "aws_route53_record" "alias" {
  name    = "${data.aws_route53_zone.mydomain_com.name}"
  type    = "A"
  zone_id = "${data.aws_route53_zone.mydomain_com.zone_id}"
  
  alias {
    name                   = "${aws_lb.app_alb.dns_name}"
    zone_id                = "${aws_lb.app_alb.zone_id}"
    evaluate_target_health = true
  }
}

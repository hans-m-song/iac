
resource "aws_route53_record" "buildsight_com_au_mx" {
  name    = "buildsight.com.au"
  type    = "MX"
  zone_id = data.aws_route53_zone.buildsight_com_au.id
  records = ["10 inbound-smtp.ap-southeast-2.amazonaws.com"]
  ttl     = 3600
}

resource "aws_route53_record" "dev_buildsight_com_au_mx" {
  name    = "dev.buildsight.com.au"
  type    = "MX"
  zone_id = data.aws_route53_zone.buildsight_com_au.id
  records = ["10 inbound-smtp.ap-southeast-2.amazonaws.com"]
  ttl     = 3600
}

resource "aws_ses_receipt_rule_set" "apse2" {
  rule_set_name = "ap-southeast-2"
  depends_on    = [aws_route53_record.buildsight_com_au_mx]
}

resource "aws_ses_active_receipt_rule_set" "apse2" {
  rule_set_name = aws_ses_receipt_rule_set.apse2.rule_set_name
  depends_on    = [aws_route53_record.buildsight_com_au_mx]
}

data "aws_route53_zone" "hsong_me" {
  provider = aws.apse2
  name     = "hsong.me"
}

resource "aws_ssm_parameter" "hsong_me_zone_id" {
  provider = aws.apse2
  name     = "/infrastructure/route53/hsong.me/hosted_zone_id"
  type     = "String"
  value    = data.aws_route53_zone.hsong_me.id
}

resource "aws_ssm_parameter" "hsong_me_zone_name" {
  provider = aws.apse2
  name     = "/infrastructure/route53/hsong.me/hosted_zone_name"
  type     = "String"
  value    = data.aws_route53_zone.hsong_me.name
}

module "hsong_me_acm_certificate" {
  providers                 = { aws = aws.use1 }
  source                    = "./modules/acm_certificate"
  zone_id                   = data.aws_route53_zone.hsong_me.zone_id
  domain_name               = "hsong.me"
  subject_alternative_names = ["*.hsong.me"]
}

resource "aws_ssm_parameter" "hsong_me_acm_certificate_arn_apse2" {
  provider = aws.apse2
  name     = "/infrastructure/acm/hsong.me/certificate_arn"
  type     = "String"
  value    = module.hsong_me_acm_certificate.arn
}

resource "aws_ssm_parameter" "hsong_me_acm_certificate_arn_use1" {
  provider = aws.use1
  name     = "/infrastructure/acm/hsong.me/certificate_arn"
  type     = "String"
  value    = module.hsong_me_acm_certificate.arn
}

data "aws_route53_zone" "buildsight_com_au" {
  provider = aws.apse2
  name     = "buildsight.com.au"
}

resource "aws_ssm_parameter" "buildsight_com_au_zone_id" {
  provider = aws.apse2
  name     = "/infrastructure/route53/buildsight.com.au/hosted_zone_id"
  type     = "String"
  value    = data.aws_route53_zone.buildsight_com_au.id
}

resource "aws_ssm_parameter" "buildsight_com_au_zone_name" {
  provider = aws.apse2
  name     = "/infrastructure/route53/buildsight.com.au/hosted_zone_name"
  type     = "String"
  value    = data.aws_route53_zone.buildsight_com_au.name
}

module "buildsight_com_au_global_acm_certificate" {
  providers                 = { aws = aws.use1 }
  source                    = "./modules/acm_certificate"
  zone_id                   = data.aws_route53_zone.buildsight_com_au.zone_id
  domain_name               = "buildsight.com.au"
  subject_alternative_names = ["*.buildsight.com.au"]
}

resource "aws_ssm_parameter" "buildsight_com_au_global_acm_certificate_arn_apse2" {
  provider = aws.apse2
  name     = "/infrastructure/acm/buildsight.com.au/certificate_arn"
  type     = "String"
  value    = module.buildsight_com_au_global_acm_certificate.arn
}

resource "aws_ssm_parameter" "buildsight_com_au_global_acm_certificate_arn_use1" {
  provider = aws.use1
  name     = "/infrastructure/acm/buildsight.com.au/certificate_arn"
  type     = "String"
  value    = module.buildsight_com_au_global_acm_certificate.arn
}

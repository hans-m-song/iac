locals {
  wheatley_issuer_hostname = "wheatley.cloud.k8s.axatol.xyz"
}

resource "auth0_client" "wheatley" {
  name        = "Wheatley"
  description = "Managed by Terraform"
}

data "auth0_client" "wheatley" {
  client_id = auth0_client.wheatley.client_id
}

resource "aws_ssm_parameter" "wheatley_client_id" {
  name  = "/app/wheatley/client_id"
  type  = "SecureString"
  value = data.auth0_client.wheatley.client_id
}

resource "aws_ssm_parameter" "wheatley_client_secret" {
  name  = "/app/wheatley/client_secret"
  type  = "SecureString"
  value = data.auth0_client.wheatley.client_id
}

resource "aws_s3_bucket" "wheatley_issuer_backend" {
  bucket_prefix = "wheatley-issuer-backend"
  force_destroy = true
}

resource "aws_s3_object" "wheatley_discovery_document" {
  bucket       = aws_s3_bucket.wheatley_issuer_backend.bucket
  key          = "discovery.json"
  content_type = "application/json"
  content = jsonencode({
    issuer                                = "https://${local.wheatley_issuer_hostname}"
    jwks_uri                              = "https://${local.wheatley_issuer_hostname}/keys.json"
    authorization_endpoint                = "urn:kubernetes:programmatic_authorization"
    response_types_supported              = ["id_token"]
    subject_types_supported               = ["public"]
    id_token_signing_alg_values_supported = ["RS256"]
    claims_supported                      = ["sub", "iss"]
  })
}

resource "aws_s3_object" "wheatley_keys_document" {
  bucket       = aws_s3_bucket.wheatley_issuer_backend.bucket
  key          = "keys.json"
  content_type = "application/json"
  content      = jsonencode({})
}

resource "aws_cloudfront_distribution" "wheatley" {
  enabled = true
  aliases = [local.wheatley_issuer_hostname]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket.wheatley_issuer_backend.id
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    origin_id   = aws_s3_bucket.wheatley_issuer_backend.id
    domain_name = aws_s3_bucket.wheatley_issuer_backend.bucket_regional_domain_name
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["AU"]
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cloud_axatol_xyz.arn
  }
}

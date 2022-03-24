data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "acm" {
  domain   = var.acm_certificate_domain
  statuses = var.statuses
}

data "aws_kms_key" "by_alias" {
  key_id = "alias/aws/es"
}

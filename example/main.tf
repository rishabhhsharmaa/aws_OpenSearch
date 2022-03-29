terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_acm_certificate" "acm" {
  domain   = var.acm_certificate_domain
  statuses = var.statuses
}

module "network_skeleton" {
  source               = "git::https://github.com/OT-CLOUD-KIT/terraform-aws-vpc.git?ref=v.0.6"
  name                 = var.name
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_vpc_logs      = false
  public_subnets_cidr  = var.public_subnets_cidr
  pvt_zone_name        = var.pvt_zone_name
  private_subnets_cidr = var.private_subnets_cidr
  avaialability_zones  = var.avaialability_zones
  logs_bucket          = var.logs_bucket
  logs_bucket_arn      = var.logs_bucket_arn
  tags                 = var.tags
  public_web_sg_name   = var.public_web_sg_name
  alb_certificate_arn  = data.aws_acm_certificate.acm.arn
}

module "aws_opensearch" {
  source = "../"
  vpc_options = [{
    subnet_ids         = [module.network_skeleton.public_subnet_ids[0], module.network_skeleton.public_subnet_ids[1]]
    security_group_ids = [module.network_skeleton.web_sg_id]
  }]
  # cognito_options = [{
  #   enabled          =  "Whether to enable Amazon Cognito authentication with Kibana"
  #   user_pool_id     =  "The ID of the Cognito User Pool to use"
  #   identity_pool_id =  "The ID of the Cognito Identity Pool to use"
  #   role_arn         =  "ARN of the IAM role that has the AmazonESCognitoAccess policy attached"
  # }]
  name                             = var.name
  tags                             = var.tags
  acm_certificate_domain           = "www.mydevopsprojects.co.in"
  statuses                         = ["ISSUED"]
  route53_zone                     = module.network_skeleton.route53_name
  route53_zone_id                  = module.network_skeleton.route53_zone_id
  domain                           = "www"
  elasticsearch_version            = "OpenSearch_1.1"
  availability_zones               = 2
  instance_count                   = 2
  instance_type                    = "m4.large.elasticsearch"
  zone_awareness_enabled           = true
  master_instance_count            = 3
  master_instance_type             = "m4.large.elasticsearch"
  warm_instance_count              = 2
  warm_instance_type               = "ultrawarm1.medium.elasticsearch"
  ebs_enabled                      = true
  volume_size                      = 10
  volume_type                      = "gp2"
  iops                             = 0
  automated_snapshot_start_hour    = 0
  enforce_https                    = true
  tls_security_policy              = "Policy-Min-TLS-1-2-2019-07"
  custom_endpoint_enabled          = true
  node_to_node_encryption          = true
  encrypt_at_rest                  = true
  advanced_security_options_enable = true
  internal_user_database_enabled   = true
  master_user_options = [{
    master_user_name     = "admin"
    master_user_password = "pUTQkenu@Y5Pn"
  }]
}

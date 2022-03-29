resource "aws_iam_service_linked_role" "es" {
  aws_service_name = var.iam_aws_service_name
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    dedicated_master_enabled = var.master_instance_count >= 2 ? true : false
    dedicated_master_count   = var.master_instance_count >= 2 ? var.master_instance_count : null
    dedicated_master_type    = var.master_instance_count >= 2 ? var.master_instance_type : null

    instance_count = var.instance_count
    instance_type  = var.instance_type

    warm_enabled = var.warm_instance_count >= 2 ? true : false
    warm_count   = var.warm_instance_count >= 2 ? var.warm_instance_count : null
    warm_type    = var.warm_instance_count >= 2 ? var.warm_instance_type : null

    zone_awareness_enabled = (var.availability_zones > 1) ? true : false

    dynamic "zone_awareness_config" {
      for_each = (var.availability_zones > 1) ? [var.availability_zones] : []
      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.ebs_enabled ? var.volume_size : null
    volume_type = var.ebs_enabled ? var.volume_type : null
    iops        = var.ebs_enabled ? var.iops : null
  }

  dynamic "vpc_options" {
    for_each = var.vpc_options
    content {
      subnet_ids         = vpc_options.value.subnet_ids
      security_group_ids = vpc_options.value.security_group_ids
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  dynamic "cognito_options" {
    for_each = var.cognito_options
    content {
      enabled          = cognito_options.value.enabled
      user_pool_id     = cognito_options.value.user_pool_id
      identity_pool_id = cognito_options.value.identity_pool_id
      role_arn         = cognito_options.value.role_arn
    }
  }

  advanced_security_options {
    enabled                        = var.advanced_security_options_enable
    internal_user_database_enabled = var.internal_user_database_enabled
    dynamic "master_user_options" {
      for_each = var.master_user_options
      content {
        master_user_name     = master_user_options.value.master_user_name
        master_user_password = master_user_options.value.master_user_password
      }
    }
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
        }
    ]
}
CONFIG

  domain_endpoint_options {
    enforce_https       = var.enforce_https
    tls_security_policy = var.enforce_https ? var.tls_security_policy : null

    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = var.custom_endpoint_enabled ? "${var.domain}.${var.route53_zone}" : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled ? data.aws_acm_certificate.acm.arn : null
  }

  dynamic "node_to_node_encryption" {
    for_each = var.node_to_node_encryption ? [1] : []
    content {
      enabled = var.node_to_node_encryption
    }
  }

  dynamic "encrypt_at_rest" {
    for_each = var.encrypt_at_rest ? [1] : []
    content {
      enabled    = var.encrypt_at_rest
      kms_key_id = data.aws_kms_key.by_alias.arn
    }
  }

  tags = merge(
    {
      Name = format("%s", var.name)
    },
    var.tags,
  )

  depends_on = [aws_iam_service_linked_role.es]
}

resource "aws_route53_record" "opensearch" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "CNAME"
  ttl     = "60"

  records = [aws_elasticsearch_domain.es.endpoint]
}

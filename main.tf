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

    zone_awareness_enabled = var.zone_awareness_enabled
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.ebs_enabled == true ? var.volume_size : null
    volume_type = var.ebs_enabled == true ? var.volume_type : null
    iops        = var.ebs_enabled == true ? var.iops : null
  }


  dynamic "vpc_options" {
    for_each = var.enable_vpc_option == true ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  advanced_security_options {
    enabled                        = var.advanced_security_options_enable
    internal_user_database_enabled = var.internal_user_database_enabled
    dynamic "master_user_options" {
      for_each = var.internal_user_database_enabled == true ? [1] : []
      content {
        master_user_name     = var.master_user_name
        master_user_password = var.master_user_password
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
    tls_security_policy = var.enforce_https == true ? var.tls_security_policy : null

    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = var.custom_endpoint_enabled == true ? "${var.domain}.${var.route53_zone}" : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled == true ? data.aws_acm_certificate.acm.arn : null
  }

  dynamic "node_to_node_encryption" {
    for_each = var.node_to_node_encryption == true ? [1] : []
    content {
      enabled = var.node_to_node_encryption
    }
  }

  dynamic "encrypt_at_rest" {
    for_each = var.encrypt_at_rest == true ? [1] : []
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


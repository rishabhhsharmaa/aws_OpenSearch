resource "aws_iam_service_linked_role" "es" {
  aws_service_name = var.iam_aws_service_name
}

resource "aws_elasticsearch_domain" "es" {
  count                 = var.opensearch_count
  domain_name           = var.domain
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    dedicated_master_enabled = var.master_instance_enabled
    dedicated_master_count   = var.master_instance_enabled == true ? var.master_instance_count : null
    dedicated_master_type    = var.master_instance_enabled == true ? var.master_instance_type : null

    instance_count = var.instance_count
    instance_type  = var.instance_type

    warm_enabled = var.warm_instance_enabled
    warm_count   = var.warm_instance_enabled == true ? var.warm_instance_count : null
    warm_type    = var.warm_instance_enabled == true ? var.warm_instance_type : null

    zone_awareness_enabled = var.zone_awareness_enabled
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_size = var.ebs_enabled == true ? var.volume_size : null
    volume_type = var.ebs_enabled == true ? var.volume_type : null
    iops        = var.ebs_enabled == true ? var.iops : null
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
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

  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest
    kms_key_id = var.encrypt_at_rest == true ? data.aws_kms_key.by_alias.arn : null
  }

  tags = merge(
    {
      Name = format("%s", var.name)
    },
    var.tags,
  )

  depends_on = [aws_iam_service_linked_role.es]
}


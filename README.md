# AWS OpenSearch Terraform Module

[![Opstree Solutions][opstree_avatar]][opstree_homepage]

[Opstree Solutions][opstree_homepage]

[opstree_homepage]: https://opstree.github.io/
[opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

OpenSearch is a distributed, open-source search and analytics suite used for a broad set of use cases like real-time application monitoring, log analytics, and website search. OpenSearch provides a highly scalable system for providing fast access and response to large volumes of data with an integrated visualization tool, OpenSearch Dashboards, that makes it easy for users to explore their data. Like Elasticsearch and Apache Solr, OpenSearch is powered by the Apache Lucene search library. OpenSearch and OpenSearch Dashboards were originally derived from Elasticsearch 7.10.2 and Kibana 7.10.2.

This module provides you the functionality to modify your opensearch as per your requirement.

**Note : For more information, you can check example folder.**

## Terraform versions

Terraform 4.8.0

## Resources

| Name                                                                                                                               | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_elasticsearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain)       | Resource    |
| [aws_iam_service_linked_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | Resource    |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | Resource    |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)              | Data Source |
| [aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate)              | Data Source |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key)                              | Data Source |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                | Data Source |

## Inputs

| Name                             | Description                                                                                                                                                          | Type           | Default | Required |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| acm_certificate_domain           | Domain of ACM                                                                                                                                                        | `string`       |         |   Yes    |
| statuses                         | Status of ACM                                                                                                                                                        | `list(string)` |         |   Yes    |
| route53_zone                     | Domain name of route53 zone                                                                                                                                          | `string`       |         |   Yes    |
| iam_aws_service_name             | IAM aws service name                                                                                                                                                 | `string`       |         |   Yes    |
| name                             | Name of resources to be created                                                                                                                                      | `string`       |         |   Yes    |
| tags                             | Additional tags for the resource                                                                                                                                     | `map(string)`  |         |   Yes    |
| opensearch_count                 | Number of OpenSearch creation                                                                                                                                        | `number`       |         |   Yes    |
| domain                           | The name of the OpenSearch Domain                                                                                                                                    | `string`       |         |   Yes    |
| elasticsearch_version            | Version of OpenSearch                                                                                                                                                | `string`       |         |   Yes    |
| instance_count                   | Number of instances in the cluster                                                                                                                                   | `number`       |         |    No    |
| instance_type                    | Instance type of data nodes in the cluster                                                                                                                           | `string`       |         |    No    |
| zone_awareness_enabled           | Whether zone awareness is enabled, set to true for multi-az deployment                                                                                               | `bool`         |         |    No    |
| master_instance_count            | Number of dedicated main nodes in the cluster                                                                                                                        | `number`       |         |    No    |
| master_instance_type             | Instance type of the dedicated main nodes in the cluster                                                                                                             | `string`       |         |    No    |
| warm_instance_count              | Number of warm nodes in the cluster. Valid values are between 2 and 150.                                                                                             | `number`       |         |    No    |
| warm_instance_type               | Instance type for the Elasticsearch cluster's warm nodes                                                                                                             | `string`       |         |    No    |
| ebs_enabled                      | Whether EBS volumes are attached to data nodes in the domain.                                                                                                        | `bool`         |         |   Yes    |
| volume_size                      | (Required if ebs_enabled is set to true.) Size of EBS volumes attached to data nodes (in GiB).                                                                       | `number`       |         |   Yes    |
| volume_type                      | Type of EBS volumes attached to data nodes.                                                                                                                          | `string`       |         |    No    |
| iops                             | Baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type                              | `number`       |         |    No    |
| vpc_options                | values would be subnet_ids and security_group_ids                                                                                                                                     | `list`         |         |   Yes    |
| advanced_security_options_enable | Whether advanced security is enabled                                                                                                                                 | `bool`         |         |   Yes    |
| internal_user_database_enabled   | Whether the internal user database is enabled. If not set, defaults to false by the AWS API.                                                                         | `bool`         |         |   Yes    |
| master_user_options                 | values would be username and password. | `list`       |         |   Yes    |
| enforce_https                    | Whether or not to require HTTPS. Defaults to true                                                                                                                    | `bool`         |         |   Yes    |
| tls_security_policy              | Name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: Policy-Min-TLS-1-0-2019-07 and Policy-Min-TLS-1-2-2019-07              | `string`       |         |   Yes    |
| custom_endpoint_enabled          | Whether to enable custom endpoint for the Elasticsearch domain                                                                                                       | `bool`         |         |   Yes    |
| node_to_node_encryption          | Whether to enable node-to-node encryption. If the node_to_node_encryption block is not provided then this defaults to false                                          | `bool`         |         |   Yes    |
| encrypt_at_rest                  | Whether to enable encryption at rest. If the encrypt_at_rest block is not provided then this defaults to false                                                       | `bool`         |         |   Yes    |

## Output

| Name | Description |
| ---- | ----------- |
| cluster_name | The name of the OpenSearch cluster. |
| cluster_version | "The version of the OpenSearch cluster." |
| cluster_endpoint | The endpoint URL of the OpenSearch cluster. |
| kibana_endpoint | The endpoint URL of Kibana. |
## Tags

- Tags are assigned to resources with name variable as prefix.
- Additial tags can be assigned by tags variables as defined above.
- Testing this.

## Related Projects

Check out these related projects.

- [AWS_NETWORK_SKELETON](https://registry.terraform.io/modules/OT-CLOUD-KIT/vpc/aws/latest)

## Usage

```hcl
module "aws_opensearch" {
  source                  = "Location of the resource file"
  vpc_options = [{
    subnet_ids         = [ subnet id's ]
    security_group_ids = [Security group id]
  }]
  name                    = aws-opensearch
  tags                    = "Required Tags"
  acm_certificate_domain  = "ACM Domain name"
  statuses                = ["ISSUED"]
  route53_zone            = "Route 53 Zone name"
  route53_zone_id         = "Route 53 Zone ID"
  domain                  = "www"
  elasticsearch_version   = "OpenSearch_1.1"
  instance_count          = 2
  instance_type           = "m4.large.elasticsearch"
  zone_awareness_enabled  = true
  master_instance_enabled = false
  master_instance_count   = 0
  master_instance_type    = "r6g.large.search"
  warm_instance_enabled   = false
  warm_instance_count     = 0
  warm_instance_type      = "ultrawarm1.medium.elasticsearch"
  ebs_enabled             = true
  volume_size             = 10
  volume_type             = "gp2"
  iops                    = 0
  enforce_https           = true
  tls_security_policy     = "Policy-Min-TLS-1-2-2019-07"
  custom_endpoint_enabled = true
  node_to_node_encryption = true
  encrypt_at_rest         = true
  advanced_security_options_enable = true
  internal_user_database_enabled   = true
  master_user_options = [{
    master_user_name     = "username"
    master_user_password = "password"
  }]
}
```

**NOTE: You can also refer the variables.tf file under example directory to get the idea on variables define in network_skeleton module.**

### Contributor

| [![Rishabh Sharma][rishabh_avatar]][rishabh_homepage]<br/>[Rishabh Sharma][rishabh_homepage] |
| -------------------------------------------------------------------------------------------- |

[rishabh_homepage]: https://www.linkedin.com/in/rishabh-sharma-b4a0b3152
[rishabh_avatar]: https://gitlab.com/uploads/-/system/user/avatar/9890362/avatar.png?width=200

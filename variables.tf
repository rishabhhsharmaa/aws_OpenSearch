# ACM data block
variable "acm_certificate_domain" {
  type        = string
  description = "(Required) Domain of ACM"
  default     = "www.mydevopsprojects.co.in"
}

variable "statuses" {
  type        = list(string)
  description = "(Required) Status of ACM"
  default     = ["ISSUED"]
}

# Route 53 data block
variable "route53_zone" {
  type        = string
  description = "(Required) Domain name of route53 zone"
}

variable "route53_zone_id" {
  type        = string
  description = "(Required) ID of route53 zone"
}

variable "iam_aws_service_name" {
  type        = string
  description = "(Required) IAM aws service name"
  default     = "es.amazonaws.com"
}

# OpenSearch Variables
variable "name" {
  description = "(Required) Name of resources to be created"
  type        = string
  default     = "aws-opensearch"
}

variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
  default = {
    "env"   = "testing"
    "owner" = "devops"
  }
}

variable "domain" {
  type        = string
  description = "The name of the OpenSearch Domain."
  default     = "www"
}

variable "elasticsearch_version" {
  type        = string
  description = "(Required) Version of OpenSearch"
  default     = "6.3"
}

# cluster_config
variable "instance_count" {
  type        = number
  description = "(Optional) Number of instances in the cluster."
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "(Optional) Instance type of data nodes in the cluster."
  default     = "m4.large.elasticsearch"
}

variable "zone_awareness_enabled" {
  type        = bool
  description = "(Optional) Whether zone awareness is enabled, set to true for multi-az deployment."
  default     = true
}

variable "master_instance_count" {
  type        = number
  description = "Optional) Number of dedicated main nodes in the cluster."
  default     = 3
}

variable "master_instance_type" {
  type        = string
  description = "(Optional) Instance type of the dedicated main nodes in the cluster."
  default     = "r6g.large.search"
}

variable "warm_instance_count" {
  type        = number
  description = "(Optional) Number of warm nodes in the cluster. Valid values are between 2 and 150."
  default     = 2
}

variable "warm_instance_type" {
  type        = string
  description = "(Optional) Instance type for the Elasticsearch cluster's warm nodes."
  default     = "ultrawarm1.medium.elasticsearch"
}

# ebs_options
variable "ebs_enabled" {
  type        = bool
  description = "(Required) Whether EBS volumes are attached to data nodes in the domain."
  default     = true
}

variable "volume_size" {
  type        = number
  description = "(Required if ebs_enabled is set to true.) Size of EBS volumes attached to data nodes (in GiB)."
  default     = 10
}

variable "volume_type" {
  type        = string
  description = "(Optional) Type of EBS volumes attached to data nodes."
  default     = "gp2"
}

variable "iops" {
  type        = number
  description = "(Optional) Baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type."
  default     = 0
}


# vpc_options
variable "enable_vpc_option" {
  type        = bool
  description = "(Required) If you want to enable VPC option"
  default     = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "(Required) Subnet id's for OpenSearch resource"
}

variable "security_group_ids" {
  type        = list(string)
  description = "(Required) Security Group id's for OpenSearch resource"
}

# advanced_security_options
variable "advanced_security_options_enable" {
  type        = bool
  description = "(Required, Forces new resource) Whether advanced security is enabled."
  default     = false
}

variable "internal_user_database_enabled" {
  type        = bool
  description = "(Optional, Default: false) Whether the internal user database is enabled. If not set, defaults to false by the AWS API."
  default     = false
}

variable "master_user_name" {
  type = string
  description = "(Optional) Main user's username, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if internal_user_database_enabled is set to true."
}

variable "master_user_password" {
  type = string
  description = "(Optional) Main user's password, which is stored in the Amazon Elasticsearch Service domain's internal database. Only specify if internal_user_database_enabled is set to true."
}

# domain_endpoint_options
variable "enforce_https" {
  type        = bool
  description = "(Optional) Whether or not to require HTTPS. Defaults to true."
  default     = true
}

variable "tls_security_policy" {
  type        = string
  description = "(Optional) Name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: Policy-Min-TLS-1-0-2019-07 and Policy-Min-TLS-1-2-2019-07. "
  default     = "Policy-Min-TLS-1-2-2019-07"
}

variable "custom_endpoint_enabled" {
  type        = bool
  description = "(Optional) Whether to enable custom endpoint for the Elasticsearch domain."
  default     = true
}

# node_to_node_encryption
variable "node_to_node_encryption" {
  type        = bool
  description = "(Required) Whether to enable node-to-node encryption. If the node_to_node_encryption block is not provided then this defaults to false."
  default     = true
}

# encrypt_at_rest
variable "encrypt_at_rest" {
  type        = bool
  description = "(Required) Whether to enable encryption at rest. If the encrypt_at_rest block is not provided then this defaults to false."
  default     = true
}

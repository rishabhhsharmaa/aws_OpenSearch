output "cluster_name" {
  description = "The name of the OpenSearch cluster."
  value       = aws_elasticsearch_domain.es.domain_name
}

output "cluster_version" {
  description = "The version of the OpenSearch cluster."
  value       = replace(aws_elasticsearch_domain.es.elasticsearch_version, "OpenSearch_", "")
}

output "cluster_endpoint" {
  description = "The endpoint URL of the OpenSearch cluster."
  value       = "https://${aws_route53_record.opensearch.fqdn}"
}

output "kibana_endpoint" {
  description = "The endpoint URL of Kibana."
  value       = "https://${aws_route53_record.opensearch.fqdn}/_dashboards/"
}
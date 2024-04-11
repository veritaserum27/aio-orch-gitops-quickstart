output "egmq_hostname" {
  value = jsondecode(azapi_resource.egmq.output).properties.topicSpacesConfiguration.hostname
}
variable "name" {
  description = "The unique primary name used when naming resources. (ex. 'test' makes 'rg-test' resource group)"
  type        = string
  nullable    = false
  validation {
    condition     = var.name != "sample-aio" && length(var.name) < 15 && can(regex("^[a-z0-9][a-z0-9-]{1,60}[a-z0-9]$", var.name))
    error_message = "Please update 'name' to a short, unique name, that only has lowercase letters, numbers, '-' hyphens."
  }
}

variable "location" {
  type    = string
  default = "westus3"
}

variable "resource_group_name" {
  description = "(Optional) The name of the Resource Group. (Otherwise, 'rg-<name>' if not bootstrapping aio or module.aio_infra.resource_group_name)"
  type        = string
  default     = null
}

variable "egmq_client_auth_name_sources" {
  description = "(Optional) Alternative naming sources for client authentication. (Otherwise, '[ClientCertificateSubject]'"
  type        = list(string)
  default     = ["ClientCertificateSubject"]
}

variable "egmq_topic_templates" {
  description = "(Optional) Specify Event Grid MQTT Topic Templates to make available. (Otherwise, '[edge/cloud/#, cloud/edge/#]', wildcards allowed ('+', '#', etc)"
  type        = list(string)
  default     = ["edge/cloud/#", "cloud/edge/#"]
}

# For Azure Event Grid MQ in the cloud
variable "egmq_cloud_to_edge_topic" {
  description = "(Optional) Specify Event Grid MQTT Topic to send to AIO. (Otherwise, 'cloud/edge/#', wildcards allowed ('+' or '#'))"
  type        = string
  default     = "cloud/edge/#"
}

# For AIO MQ on the edge
variable "egmq_cloud_to_edge_topic_target" {
  description = "(Optional) Specify AIO MQ Topic to receive Event Grid MQTT Topic data. (Otherwise, 'cloud/data', wildcards not allowed)"
  type        = string
  default     = "cloud/data"
}

# For AIO MQ on the edge
variable "egmq_edge_to_cloud_topic" {
  description = "(Optional) Specify AIO MQ Topic to send to Event Grid MQTT Topic. (Otherwise, 'azure-iot-operations/data/#', wildcards allowed ('+' or '#'))"
  type        = string
  default     = "azure-iot-operations/data/#"
}

# For Azure Event Grid MQ in the cloud
variable "egmq_edge_to_cloud_topic_target" {
  description = "(Optional) Specify Event Grid MQTT Topic to receive AIO MQTT Topic data. (Otherwise, 'edge/cloud/data', wildcards not allowed)"
  type        = string
  default     = "edge/cloud/data"
}

variable "egmq_client_root_ca_subject_common_name" {
  description = "(Optional) The Event Grid MQTT Client root CA that will be used to sign client certificates for local testing. (Otherwise, 'subject.common_name = 'LocalRootCA')"
  type        = string
  default     = "LocalRootCA"
}

variable "egmq_client_local_ca_subject_common_name" {
  description = "(Optional) The Event Grid MQTT Client local CA that will be used to sign client certificates for local testing. (Otherwise, 'subject.common_name = 'LocalCA')"
  type        = string
  default     = "LocalCA"
}

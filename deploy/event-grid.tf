resource "azapi_resource" "egmq" {
  type      = "Microsoft.EventGrid/namespaces@2023-12-15-preview"
  name      = "eg-${var.name}"
  location  = var.location
  parent_id = data.azurerm_resource_group.this.id

  body = jsonencode({
    properties = {
      topicSpacesConfiguration = {
        state = "Enabled"
        clientAuthentication = {
          alternativeAuthenticationNameSources = var.egmq_client_auth_name_sources
        }
        maximumClientSessionsPerAuthenticationName = 5
        maximumSessionExpiryInHours                = 1
      }
    }

    sku = {
      capacity = 5
      name     = "Standard"
    }

    identity = {
      type = "SystemAssigned"
    }
  })

  response_export_values = ["properties.topicSpacesConfiguration.hostname"]
}

resource "azapi_resource" "egmq_topic_spaces" {
  type      = "Microsoft.EventGrid/namespaces/topicSpaces@2023-12-15-preview"
  name      = "aio"
  parent_id = azapi_resource.egmq.id
  body = jsonencode({
    properties = {
      topicTemplates = var.egmq_topic_templates
    }
  })
}

resource "azapi_resource" "egmq_permission_bindings_subscriber" {
  type      = "Microsoft.EventGrid/namespaces/permissionBindings@2023-12-15-preview"
  name      = "aio-subscriber"
  parent_id = azapi_resource.egmq.id
  body = jsonencode({
    properties = {
      clientGroupName = "$all"
      permission      = "Subscriber"
      topicSpaceName  = azapi_resource.egmq_topic_spaces.name
    }
  })
}

resource "azapi_resource" "event_grid_permission_binding_publisher" {
  type      = "Microsoft.EventGrid/namespaces/permissionBindings@2023-12-15-preview"
  name      = "aio-publisher"
  parent_id = azapi_resource.egmq.id
  body = jsonencode({
    properties = {
      clientGroupName = "$all"
      permission      = "Publisher"
      topicSpaceName  = azapi_resource.egmq_topic_spaces.name
    }
  })
}

data "tls_certificate" "local_client" {
  content = tls_locally_signed_cert.local_client.cert_pem
}

resource "azapi_resource" "event_grid_local_client" {
  type      = "Microsoft.EventGrid/namespaces/clients@2023-12-15-preview"
  name      = "local-client"
  parent_id = azapi_resource.egmq.id
  body = jsonencode({
    properties = {
      authenticationName = "local-client"
      clientCertificateAuthentication = {
        allowedThumbprints = [
          data.tls_certificate.local_client.certificates[0].sha1_fingerprint
        ]
        validationScheme = "ThumbprintMatch"
      }
      description = "Local client certificate for testing"
      state       = "Enabled"
    }
  })
}
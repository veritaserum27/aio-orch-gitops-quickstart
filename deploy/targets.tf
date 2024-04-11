resource "azapi_resource" "aio_targets_cluster" {
  schema_validation_enabled = false
  type                      = "Microsoft.IoTOperationsOrchestrator/targets@2023-10-04-preview"
  name                      = "cluster"
  location                  = var.location
  parent_id                 = data.azurerm_resource_group.this.id

  depends_on = [
    module.aio_full,
    module.opc_plc_sim
  ]

  body = jsonencode({
    extendedLocation = {
      name = local.custom_locations_id
      type = "CustomLocation"
    }

    properties = {
      scope   = "azure-iot-operations"
      version = "1.0.0"
      components = [
        {
          name = "egmq-mqtt-bridge-connector"
          type = "yaml.k8s"
          properties = {
            resource = yamldecode(
              templatefile(
                "${path.module}/manifests/egmq-mqtt-bridge-connector.yaml", {
                  egmq_name = azapi_resource.egmq.name
                  location  = var.location
                }
            ))
          }
        },
        {
          name = "egmq-mqtt-bridge-topic-map"
          type = "yaml.k8s"
          properties = {
            resource = yamldecode(
              templatefile(
                "${path.module}/manifests/egmq-mqtt-bridge-topic-map.yaml", {
                  cloud_to_edge_topic        = var.egmq_cloud_to_edge_topic
                  cloud_to_edge_topic_target = var.egmq_cloud_to_edge_topic_target
                  edge_to_cloud_topic        = var.egmq_edge_to_cloud_topic
                  edge_to_cloud_topic_target = var.egmq_edge_to_cloud_topic_target
                }
            ))
          }
        },
      ]

      topologies = [{
        bindings = [
          {
            role     = "yaml.k8s"
            provider = "providers.target.kubectl"
            config = {
              inCluster = "true"
            }
          },
          {
            role     = "helm.v3"
            provider = "providers.target.helm"
            config = {
              inCluster = "true"
            }
          },
        ]
      }]
    }
  })
}
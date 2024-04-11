resource "azurerm_role_assignment" "aio_mq_eg_topicspaces_publisher" {
  scope                = azapi_resource.egmq_topic_spaces.id
  principal_id         = module.aio_full.aio_mq_principal_id
  role_definition_name = "EventGrid TopicSpaces Publisher"
}

resource "azurerm_role_assignment" "aio_mq_eg_topicspaces_subscriber" {
  scope                = azapi_resource.egmq_topic_spaces.id
  principal_id         = module.aio_full.aio_mq_principal_id
  role_definition_name = "EventGrid TopicSpaces Subscriber"
}

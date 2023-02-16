param location string = resourceGroup().location
param eventSubName string = 'subToStorage'
param webhookEndpoint string
param systemTopicName string = 'mystoragesystemtopic'
param storageAccountName string
param defaultTags object

// @description('The name of the Event Grid custom topic.')
// param eventGridTopicName string = 'topic-${uniqueString(resourceGroup().id)}'

// @description('The name of the Event Grid custom topic\'s subscription.')
// param eventGridSubscriptionName string = 'sub-${uniqueString(resourceGroup().id)}'

// @description('The webhook URL to send the subscription events to. This URL must be valid and must be prepared to accept the Event Grid webhook URL challenge request.')
// param eventGridSubscriptionUrl string

// @description('The location in which the Event Grid should be deployed.')
// param location string = resourceGroup().location

// resource eventGridTopic 'Microsoft.EventGrid/topics@2020-06-01' = {
//   name: eventGridTopicName
//   location: location
// }

// resource eventGridSubscription 'Microsoft.EventGrid/eventSubscriptions@2020-06-01' = {
//   name: eventGridSubscriptionName
//   scope: eventGridTopic
//   properties: {
//     destination: {
//       endpointType: 'WebHook'
//       properties: {
//         endpointUrl: eventGridSubscriptionUrl
//       }
//     }
//   }
// }

// Reference Existing resource
resource existing_storageaccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource systemTopic 'Microsoft.EventGrid/systemTopics@2022-06-15' = {
  name: systemTopicName
  location: location
  tags: defaultTags
  properties: {
    source: existing_storageaccount.id
    topicType: 'Microsoft.Storage.StorageAccounts'
  }
}

// resource eventSubscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2022-06-15' = {
//   parent: systemTopic
//   name: eventSubName
//   properties: {
//     destination: {
//       properties: {
//         endpointUrl: 'https://${webhookEndpoint}.azurewebsites.net/api/updates'
//       }
//       endpointType: 'WebHook'
//     }
//     filter: {
//       includedEventTypes: [
//         'Microsoft.Storage.BlobCreated'
//         'Microsoft.Storage.BlobDeleted'
//       ]
//     }
//   }
// }

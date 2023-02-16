param storageAccountName string
param containerName1 string = 'images'
param containerName2 string = 'imagesthumbnails'
param location string = resourceGroup().location
param defaultTags object
// param eventSubName string = 'subToStorage'
// param webhookEndpoint string
// param systemTopicName string = 'mystoragesystemtopic'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  tags: defaultTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
  }
}

resource container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccount.name}/default/${containerName1}'
}
resource container2 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: '${storageAccount.name}/default/${containerName2}'
}

// resource systemTopic 'Microsoft.EventGrid/systemTopics@2022-06-15' = {
//   name: systemTopicName
//   location: location
//   properties: {
//     source: storageAccount.id
//     topicType: 'Microsoft.Storage.StorageAccounts'
//   }
// }

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

// Deploy Azure infrastructure for app + data + monitoring

//targetScope = 'subscription'
// Region for all resources
param location string = resourceGroup().location
param appName string = 'Image Processing'
param createdBy string = 'Randy Pagels' // resourceGroup().managedBy
param costCenter string = '74f644d3e665'
param releaseAnnotationGuid string = newGuid()

// Variables for Recommended abbreviations for Azure resource types
// https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
var webAppPlanName = 'plan-${uniqueString(resourceGroup().id)}'
var webSiteName = 'app-${uniqueString(resourceGroup().id)}'
var appInsightsName = 'appi-${uniqueString(resourceGroup().id)}'
var appInsightsWorkspaceName = 'appw-${uniqueString(resourceGroup().id)}'
var appInsightsAlertName = 'ResponseTime-${uniqueString(resourceGroup().id)}'
var functionAppName = 'func-${uniqueString(resourceGroup().id)}'
var functionAppServiceName = 'funcplan-${uniqueString(resourceGroup().id)}'
var apiServiceName = 'apim-${uniqueString(resourceGroup().id)}'
var keyvaultName = 'kv-${uniqueString(resourceGroup().id)}'
var blobstorageName = 'stablob${uniqueString(resourceGroup().id)}'
var cognitiveServiceName = 'cog-${uniqueString(resourceGroup().id)}'


// Tags
var defaultTags = {
  AppName: appName
  CostCenter: costCenter
  CreatedBy: createdBy
}

// KeyVault Secret Names
param kvValue_configStoreConnectionName string = 'ConnectionStringsAppConfig'
param kvValue_ConnectionStringName string = 'ConnectionStringsMercuryHealthWebContext'
param kvValue_AzureWebJobsStorageName string = 'AzureWebJobsStorage'
param kvValue_WebsiteContentAzureFileConnectionString string = 'WebsiteContentAzureFileConnectionString'
param kvValue_ApimSubscriptionKeyName string = 'ApimSubscriptionKey'


// Create Azure KeyVault
module keyvaultmod './main-keyvault.bicep' = {
  name: keyvaultName
  params: {
    location: location
    vaultName: keyvaultName
    }
 }
 
// Create Web App
module webappmod './main-webapp.bicep' = {
  name: 'webappdeploy'
  params: {
    webAppPlanName: webAppPlanName
    webSiteName: webSiteName
    resourceGroupName: resourceGroup().name
    appInsightsName: appInsightsName
    location: location
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    appInsightsConnectionString: appinsightsmod.outputs.out_appInsightsConnectionString
    defaultTags: defaultTags
 }
}

// Create Application Insights
module appinsightsmod './main-appinsights.bicep' = {
  name: 'appinsightsdeploy'
  params: {
    location: location
    appInsightsName: appInsightsName
    defaultTags: defaultTags
    appInsightsAlertName: appInsightsAlertName
    appInsightsWorkspaceName: appInsightsWorkspaceName
  }
}

// Create Function App
module functionappmod './main-funcapp.bicep' = {
  name: 'functionappdeploy'
  params: {
    location: location
    functionAppServiceName: functionAppServiceName
    functionAppName: functionAppName
    defaultTags: defaultTags
  }
  dependsOn:  [
    appinsightsmod
  ]
}

// Create API Management
// module apimservicemod './main-apimanagement.bicep' = {
//   name: apiServiceName
//     params: {
//     location: location
//     defaultTags: defaultTags
//     apiServiceName: apiServiceName
//     appInsightsName: appInsightsName
//     applicationInsightsID: appinsightsmod.outputs.out_applicationInsightsID
//     appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
//     webSiteName: webSiteName
    
//   }
//   dependsOn:  [
//     appinsightsmod
//   ]
// }

module blogstoragemod './main-blobstorage.bicep' = {
  name: blobstorageName
  params: {
    location: location
     storageAccountName: blobstorageName
     webhookEndpoint: webappmod.outputs.out_webSiteName
  }
  dependsOn:  [
    webappmod
  ]
}

// module cognitiveservicemod './main-cognitiveservice.bicep' = {
//   name: cognitiveServiceName
//   params: {
//     defaultTags: defaultTags
//     cognitiveServiceName: cognitiveServiceName
//     location: location
//   }
// }

//param AzObjectIdPagels string = 'b6be0700-1fda-4f88-bf20-1aa508a91f73'
param AzObjectIdPagels string = '197b8610-80f8-4317-b9c4-06e5b3246e87'

// Application Id of Service Principal "MercuryHealth_ServicePrincipal"
//param ADOServiceprincipalObjectId string = '5bc20bf4-172c-48ac-86e7-a5185394237b'
//aram ADOServiceprincipalObjectId string = 'e7f4d4b8-26e0-452a-868f-6818be23ef73'
param ADOServiceprincipalObjectId string = '61ad559f-a07a-4d8f-981b-c88e69216dd1'

// Create Configuration Entries
module configsettingsmod './main-configsettings.bicep' = {
  name: 'configSettings'
  params: {
    keyvaultName: keyvaultName
    appServiceprincipalId: webappmod.outputs.out_appServiceprincipalId
    webappName: webSiteName
    functionAppName: functionAppName
    funcAppServiceprincipalId: functionappmod.outputs.out_funcAppServiceprincipalId
    kvValue_AzureWebJobsStorageName: kvValue_AzureWebJobsStorageName
    kvValue_AzureWebJobsStorageValue: functionappmod.outputs.out_AzureWebJobsStorage
    kvValue_WebsiteContentAzureFileConnectionStringName: kvValue_WebsiteContentAzureFileConnectionString
    kvValue_ApimSubscriptionKeyName: kvValue_ApimSubscriptionKeyName
    //kvValue_ApimSubscriptionKeyValue: apimservicemod.outputs.out_ApimSubscriptionKeyString
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    appInsightsConnectionString: appinsightsmod.outputs.out_appInsightsConnectionString
    //ApimWebServiceURL: apimservicemod.outputs.out_ApimWebServiceURL
    AzObjectIdPagels: AzObjectIdPagels
    ADOServiceprincipalObjectId: ADOServiceprincipalObjectId
    }
    dependsOn:  [
     keyvaultmod
     webappmod
     functionappmod
   ]
 }

// Output Params used for IaC deployment in pipeline
output out_webSiteName string = webSiteName
output out_appInsightsName string = appInsightsName
output out_functionAppName string = functionAppName
output out_apiServiceName string = apiServiceName
//output out_apimSubscriptionKey string = apimservicemod.outputs.out_ApimSubscriptionKeyString
output out_keyvaultName string = keyvaultName
output out_appInsightsApplicationId string = appinsightsmod.outputs.out_appInsightsApplicationId
output out_appInsightsAPIApplicationId string = appinsightsmod.outputs.out_appInsightsAPIApplicationId
output out_releaseAnnotationGuidID string = releaseAnnotationGuid

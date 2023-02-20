//borrowed and modified from https://arinco.com.au/blog/checking-for-resource-existence-in-bicep/

targetScope = 'resourceGroup'

@description('Resource name to check in current scope (resource group)')
param resourceName string

param location string = resourceGroup().location
param utcValue string = utcNow()
param asSettings object

// used to pass into deployment script
var resourceGroupName = resourceGroup().name
var jq = '{Result: map({name: .name})}'

// The script below performs an 'az resource list' command to determine whether a resource exists
resource resource_exists_script 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'resource_exists'
  location: location
  kind: 'AzureCLI'
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: '2.40.0'
    timeout: 'PT10M'
    arguments: '\'${resourceGroupName}\' \'${resourceName}\' \'${asSettings.tenant}\' \'${asSettings.servicePrincipalPass}\' \'${asSettings.servicePrincipal}\' \'{Result: map({name: .name})}\''
    // replace service princapal and pass values in, maybe by key vault
    scriptContent: 'az login --service-principal --username ${asSettings.servicePrincipal} --tenant ${asSettings.tenant} --password ${asSettings.servicePrincipalPass}; result=$(az resource list --resource-group ${resourceGroupName} --name ${resourceName}); echo $result; echo $result | jq -c \'${jq}\' > $AZ_SCRIPTS_OUTPUT_PATH'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}

//output exists bool = length(resource_exists_script.properties.outputs.Result) > 0
output exists array = resource_exists_script.properties.outputs.Result

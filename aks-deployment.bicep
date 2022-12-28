//set sccope to subscription so resource group can create deployment
targetScope = 'subscription'

// ########################
// ######## Params ########
// ########################

// name of group of rsources
param resourcePrefix string

// right now default vm size is only avaiable in useast
// sets location of all resources to what location is passed during deploy
param location string = deployment().location

// kube version to build AKS
@allowed(
  [
    '1.23.12'
    '1.23.24.6'
    '1.25.4'
  ]
)
param kubeVersion string = '1.23.12'

// number of worker nodes in AKS cluster 
@allowed([
  1
  2
  3
])
param nodeCount int = 1

/* @secure()
param pass string  */

// env that sets VM Size
@allowed([
  'dev'
  'prod'
])
param env string = 'dev'

// sku tier type
@allowed([
  'Free'
  'Paid'
])
param aksSkuTier string = 'Free'

// ########################
// ######### Vars #########
// ########################

// sets resource group name
var resourceGroupName = '${resourcePrefix}-rg'

// sets VM size based of env param
var vmSize = (env == 'prod') ? 'Standard_D2s_v3': 'Standard_B2ms'

// ########################
// ###### Resources #######
// ########################

// creates resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
}

// ########################
// ####### Modules ########
// ########################

// calls aks cluster bicep file and runs with provided parms
module aks './modules/aks-cluster.bicep' = {
  name: '${resourcePrefix}-cluster'
  scope: rg
  params: {
    aksSettings: {
      location: location
      clusterName: resourcePrefix
      nodeCount: nodeCount
      vmSize: vmSize
      kubeVersion: kubeVersion
      sku_tier: aksSkuTier
  }
}
}

// ########################
// ######## Params ########
// ########################

// param object passed from deployment bicep
param aksSettings object = {
  //kubeVersion: null
}

// ########################
// ###### Resources #######
// ########################

// creates aks cluster with config from aksSettings object
resource aks 'Microsoft.ContainerService/managedClusters@2022-09-01' = {
  name: '${aksSettings.clusterName}-cluster'
  location: aksSettings.location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Basic'
    tier: aksSettings.sku_tier
  }
  properties: {
    kubernetesVersion: aksSettings.kubeVersion
    dnsPrefix: aksSettings.clusterName
    enableRBAC: false
    agentPoolProfiles: [
      {
        name: '${aksSettings.clusterName}ap1'
        count: aksSettings.nodeCount
        vmSize: aksSettings.vmSize
        mode: 'System'
      }
    ]
  }
}

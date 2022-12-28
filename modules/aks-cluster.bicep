//param location string
//param clusterName string
//param nodeCount int
//param vmSize string 
//param kubeVersion string


param aksSettings object = {
  //kubeVersion: null
}

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

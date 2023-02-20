// ########################
// ######## Params ########
// ########################

// param object passed from deployment bicep
param asSettings object = {
  //kubeVersion: null
}

// ########################
// ###### Resources #######
// ########################

resource appservice 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${asSettings.name}-appservice'
  location: asSettings.location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: asSettings.sku.name
    tier: asSettings.sku.tier
  }
}

resource customHostNameNoSSL 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  name: '${asSettings.name}nossl'
  properties: {
    siteName: '${asSettings.name}.com'
    hostNameType: 'Verified'
    sslState: 'Disabled'
  }
}
// ########################
// ######## Output ########
// ########################

output appServiceId string = appservice.id

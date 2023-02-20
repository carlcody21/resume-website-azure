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

resource cert 'Microsoft.Web/certificates@2022-03-01' = {
  name: '${asSettings.name}.com-cert'
  location: asSettings.location
  properties: {
    serverFarmId: asSettings.appServiceId
    canonicalName: '${asSettings.name}.com'
  }
}

resource customHostname 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  name: '${asSettings.name}-wa/${asSettings.name}.com'
  properties: {
    siteName: '${asSettings.name}.com'
    hostNameType: 'Verified'
    sslState: 'SniEnabled'
    thumbprint: cert.properties.thumbprint
  }
}

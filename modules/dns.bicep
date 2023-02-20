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

resource dns_zone_new 'Microsoft.Network/dnsZones@2018-05-01' = if(!asSettings.dnsExists) {
  name: '${asSettings.name}.com'
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

resource dns_zone 'Microsoft.Network/dnsZones@2018-05-01' existing =  {
  name: '${asSettings.name}.com'
}

// ########################
// ######## Output ########
// ########################

// have to set nameservers in google domains 
output dns_ns_servers array = dns_zone.properties.nameServers

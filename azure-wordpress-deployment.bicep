//set sccope to subscription so resource group can create deployment
targetScope = 'subscription'

// ########################
// ######## Params ########
// ########################

param sites array 

// ########################
// ######### vars #########
// ########################

//var sites_length = length(sites)

// sets location of all resources to what location is passed during deploy
param location string = deployment().location

//param name string

//param dnsname string

//param sku object

//param dockerimage string

@description('Database admin password')
@minLength(8)
@secure()
param adminPassword string

@description('Service Principal password')
@minLength(8)
@secure()
param servicePrincipalPass string

// ########################
// ######### Vars #########
// ########################

// ########################
// ###### Resources #######
// ########################

// creates resource group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = [for (s, index) in sites: {
  name: '${s.name}-rg'
  location: location
}]

// ########################
// ####### Modules ########
// ########################

module dns_resource_check './modules/check_if_resource_exists.bicep' = [for (s, index) in sites: {
  scope: rg[index]
  name: '${s.name}-dnscheck'
  params: {
    location: location
    resourceName: '${s.name}.com'
    asSettings: {
      servicePrincipalPass: servicePrincipalPass
      servicePrincipal: s.servicePrincipal
      tenant: s.tenant
    }
  }
}]

module mysql_resource_check './modules/check_if_resource_exists.bicep' = [for (s, index) in sites: {
  dependsOn: dns_resource_check
  scope: rg[index]
  name: '${s.name}-mysqlcheck'
  params: {
    location: location
    resourceName: '${s.name}-mysql'
    asSettings: {
      servicePrincipalPass: servicePrincipalPass
      servicePrincipal: s.servicePrincipal
      tenant: s.tenant
    }
  }
}]

module mysql './modules/mysql-server.bicep' = [for (s, index) in sites: {
  dependsOn: mysql_resource_check
  name: '${s.name}-mysqlmodule'
  scope: rg[index]
  params: {
    asSettings: {
      mysqlExists: length(mysql_resource_check[index].outputs.exists) > 0
      name: s.name
      location: location
      sku: s.sku
      adminPassword: adminPassword
    }
  }
}]

module dns './modules/dns.bicep' = [for (s, index) in sites: {
  dependsOn: dns_resource_check
  name: '${s.name}-dnsmodule'
  scope: rg[index]
  params: {
    asSettings: {
      name: s.name
      dnsExists: length(dns_resource_check[index].outputs.exists) > 0
    }
  }
}]

module app './modules/app.bicep' = [for (s, index) in sites: {
  name: '${s.name}-app'
  scope: rg[index]
  params: {
    asSettings: {
      name: s.name
      location: location
      dockerimage: s.dockerimage
      mysql_fqdn: mysql[index].outputs.mysql_server_fqdn
      adminPassword: adminPassword
      sku: s.sku
      txtRecordValue: s.txtRecordValue
    }
  }
}]

module cert_domain './modules/cert-domain.bicep' = [for (s, index) in sites: {
  name: '${s.name}-cert-domain'
  scope: rg[index]
  params: {
    asSettings: {
      name: s.name
      appServiceId: app[index].outputs.appServiceId
      location: location
    }
  }
  }]

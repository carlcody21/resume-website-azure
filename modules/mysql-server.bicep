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

resource mysql_create 'Microsoft.DBforMySQL/servers@2017-12-01' = if(!asSettings.mysqlExists) {
  name: '${asSettings.name}-mysql'
  location: asSettings.location
  sku: {
         name: 'B_Gen5_1'
         tier: asSettings.sku.tier
         capacity: 1
         family: 'Gen5'
  }
  properties: {
    createMode: 'Default'
    version: '5.7'
    administratorLogin: 'mysqladmin'
    administratorLoginPassword: asSettings.adminPassword
    storageProfile: {
      storageMB: 5120
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    sslEnforcement: 'Disabled'
  }
  
  resource allow_app_to_mysql 'firewallRules@2017-12-01' = {
    name: 'AllowAppToMySql'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '255.255.255.255'
    }
  }
}

resource mysql 'Microsoft.DBforMySQL/servers@2017-12-01' existing = {
  name: '${asSettings.name}-mysql'
}

// ########################
// ###### Outputs #######
// ########################

output mysql_server_fqdn string = mysql.properties.fullyQualifiedDomainName
output mysql_name string = mysql.name
output mysql_id string = mysql.id
output mysql_type string = mysql.type

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

resource mysql 'Microsoft.DBforMySQL/servers@2017-12-01' existing = {
  name: '${asSettings.name}-mysql'
}

resource mysql_database 'Microsoft.DBforMySQL/servers/databases@2017-12-01' = {
  parent: mysql
  name: '${asSettings.name}-wordpress'
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}

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

resource webapp 'Microsoft.Web/sites@2022-03-01' = {
  //dependsOn: [cert]
  name: '${asSettings.name}-wa'
  location: asSettings.location
  tags: {}
  properties: {
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'WORDPRESS_DB_PASSWORD'
          value: asSettings.adminPassword
        }
        {
          name: 'WORDPRESS_DB_HOST'
          value: asSettings.mysql_fqdn 
        }
        {
          name: 'WORDPRESS_DB_USER'
          value: 'mysqladmin'
        }
        {
          name: 'WORDPRESS_DB_NAME'
          value: mysql_database.name
        }
      ]
      linuxFxVersion: asSettings.dockerimage
      //connectionStrings: [
      //  { 
      //    name: 'defaultConn'
      //    connectionString: 'Database=${asSettings.databaseName};Data Source=${mysql.properties.fullyQualifiedDomainName};User Id=${asSettings.adminLogin}@${mysql.name};Password=${asSettings.adminPassword}'
      //    type: 'MySql'
      //  }
      //]
    }
    serverFarmId: appservice.id
  }
}

resource customHostname 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  name: '${asSettings.name}.com'
  parent: webapp
  properties: {
    siteName: '${asSettings.name}.com'
    hostNameType: 'Verified'
    sslState: 'Disabled'  //'SniEnabled'
//    //thumbprint: cert.properties.thumbprint
  }
}

resource dns_zone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: '${asSettings.name}.com'
  resource dns_arecord 'A@2018-05-01' = {
    name: toLower('@')
    //parent: dns_zone
    properties: {
      TTL: 3600
      ARecords: [
        {
          ipv4Address: last(split(webapp.properties.outboundIpAddresses, ','))
        }
      ]
    }
  }
  resource dns_txtrecord 'TXT@2018-05-01' = {
    name: toLower('asuid')
    properties: {
      TTL: 36600
      TXTRecords: [
        {
          value: array(asSettings.txtRecordValue)
        }
      ]
    }
  }
}

// ########################
// ######## Output ########
// ########################

output appServiceId string = appservice.id

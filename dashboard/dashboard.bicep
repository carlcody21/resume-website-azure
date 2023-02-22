param servicePlan object

param location string = resourceGroup().location

module servicePlanTiles './modules/service-plan-tiles.bicep' =  {
  name: '${servicePlan.name}-service-plan-tiles'
  params: {
    servicePlanId: resourceId(servicePlan.resourceGroup, 'Microsoft.Web/serverfarm', servicePlan.name)
    servicePlanName: servicePlan.name
  }
}

resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: 'testingd-dashboard'
  location: location
  //tags: tags
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 3
              colSpan: 5
            }
            metadata: servicePlanTiles.outputs.combinedUsageTile
          }
        ]
      }
    ]
  }
}

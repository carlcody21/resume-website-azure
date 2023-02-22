param servicePlans array

param location string = resourceGroup().location

var rows = (length(servicePlans) % 2) == 0 ? length(servicePlans) / 2 : length(servicePlans) % 2

//module servicePlanTiles './modules/service-plan-tiles2.bicep' =  {
 // name: 'adf-service-plan-tiles'
 // params: {
 //   servicePlans: servicePlans
    //servicePlanId: resourceId(servicePlan.resourceGroup, 'Microsoft.Web/serverfarm', servicePlan.name)
    //servicePlanName: servicePlan.name
//  }
//}

module servicePlanParts './modules/parts.bicep' = {
  name: 'test'
  params: {
    servicePlans: servicePlans
    rows: rows
  }
}


//second array that holds positions, don't use same array
//if mod x/6 returns 0 x == 0 and y + 6, then lenghtn(array)/2 is how many rows is needed, mod to check for odd
resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: 'testingd-dashboard'
  location: location
  //tags: tags
  properties: {
    lenses: [
      {
        order: 0
        parts: servicePlanParts.outputs.parts //[
        //  {
        //    position: {
        //      x: 0
        //      y: 0
        //      rowSpan: 3
        //      colSpan: 5
        //    }
        //    metadata: servicePlanTiles.outputs.combinedUsageTile
        //  }
        //]
      }
    ]
  }
}

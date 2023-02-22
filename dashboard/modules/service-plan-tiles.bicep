
param servicePlanId string
param servicePlanName string
param deploymentNamePostfix string = ''

module servicePlanCpuUsageTile './metrics-tile.bicep' = {
  name: 'service-plan-cpu-usage-chart${deploymentNamePostfix}'
  params: {
    title: 'Service Plan CPU Usage'
    metrics: [
      {
        displayName: 'Service Plan CPU Usage'
        resourceId: servicePlanId
        resourceDisplayName: servicePlanName
        metricNamespace: 'microsoft.web/serverfarms'
        metricName: 'CpuPercentage'
        aggregation: 'Avg'
      }
    ]
  }
}

module servicePlanMemoryUsageTile './metrics-tile.bicep' = {
  name: 'service-plan-memory-usage-chart${deploymentNamePostfix}'
  params: {
    title: 'Service Plan Memory Usage'
    metrics: [
      {
        displayName: 'Service Plan Memory Usage'
        resourceId: servicePlanId
        resourceDisplayName: servicePlanName
        metricNamespace: 'microsoft.web/serverfarms'
        metricName: 'MemoryPercentage'
        aggregation: 'Avg'
      }
    ]
  }
}

module servicePlanCombinedUsageTile './metrics-tile.bicep' = {
  name: 'service-plan-combined-usage-chart${deploymentNamePostfix}'
  params: {
    title: '${servicePlanName} - Usage'
    metrics: [
      {
        displayName: 'Service Plan CPU Usage'
        resourceId: servicePlanId
        resourceDisplayName: servicePlanName
        metricNamespace: 'microsoft.web/serverfarms'
        metricName: 'CpuPercentage'
        aggregation: 'Avg'
      }
      {
        displayName: 'Service Plan Memory Usage'
        resourceId: servicePlanId
        resourceDisplayName: servicePlanName
        metricNamespace: 'microsoft.web/serverfarms'
        metricName: 'MemoryPercentage'
        aggregation: 'Avg'
      }
    ]
  }
}

output cpuUsageTile object = servicePlanCpuUsageTile.outputs.tile
output memoryUsageTile object = servicePlanMemoryUsageTile.outputs.tile
output combinedUsageTile object = servicePlanCombinedUsageTile.outputs.tile

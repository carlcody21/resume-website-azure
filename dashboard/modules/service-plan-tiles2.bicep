
param servicePlans array

module servicePlanCombinedUsageTile './metrics-tile.bicep' = [for plan in servicePlans: {
  name: 'service-plan-combined-usage-chart$'
  params: {
    title: '${plan.name} - Usage'
    metrics: [
      {
        displayName: 'Service Plan CPU Usage'
        resourceId: plan.id
        resourceDisplayName: resourceId(plan.resourceGroup, 'Microsoft.Web/serverfarm', plan.name)
        metricNamespace: 'microsoft.web/serverfarms'
        metricName: 'CpuPercentage'
        aggregation: 'Avg'
      }
      {
        displayName: 'Service Plan Memory Usage'
        resourceId: resourceId(plan.resourceGroup, 'Microsoft.Web/serverfarm', plan.name)
        resourceDisplayName: plan.name
        metricNamespace: 'microsoft.web/serverfarms'
        metricName: 'MemoryPercentage'
        aggregation: 'Avg'
      }
    ]
  }
}]

output combinedUsageTile array = servicePlanCombinedUsageTile

param title string
param metrics array

var metricsValue = [for metric in metrics: {
  resourceMetadata: {
    id: metric.resourceId
  }
  namespace: metric.metricNamespace
  name: metric.metricName
  aggregationType: 4
  metricVisualization: {
    displayName: metric.displayName
    resourceDisplayName: metric.resourceDisplayName
  }
}]

output tile object = {
    type: 'Extension/HubsExtension/PartType/MonitorChartPart'
    inputs: [
    ]
    settings: {
      content: {
        options: {
          chart: {
            title: title
            metrics: metricsValue
          }
        }
      }
    }
}

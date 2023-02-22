param title string
param metrics array

// aggregation type:
// 1 = sum
// 2 = min
// 3 = max
// 4 = average
// 7 = count

var metricsValue = [for metric in metrics: {
  resourceMetadata: {
    id: metric.resourceId
  }
  namespace: metric.metricNamespace
  name: metric.metricName
  aggregationType: metric.aggregation == 'Sum' ? 1 : (metric.aggregation == 'Min' ? 2 : (metric.aggregation == 'Max' ? 3 : (metric.aggregation == 'Avg' ? 4 : 7)))
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

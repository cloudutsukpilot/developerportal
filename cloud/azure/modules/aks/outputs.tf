output "aks_clusters_output" {
  description = "The name of the aks clusters"
  value = {
    for cluster in azurerm_kubernetes_cluster.aks_clusters : cluster.name => {
      name = cluster.name
      id   = cluster.id
    }
  }
}

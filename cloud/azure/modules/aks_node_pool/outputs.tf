output "aks_node_pools" {
    description = "output of the aks node pools"
    value =  {
        for node_pool in azurerm_kubernetes_cluster_node_pool.aks_node_pools : node_pool.name => {
            name = node_pool.name
            id   = node_pool.id
        }
    }
  
}
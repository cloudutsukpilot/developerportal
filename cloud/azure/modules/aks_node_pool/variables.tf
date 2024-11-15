variable "aks_cluster_node_pools" {
  description = "A map of AKS cluster node pool configurations with related attributes for each node pool."
  type = map(object({
    name                       = string
    kubernetes_cluster_id      = string
    vm_size                    = string
    node_count                 = number
    auto_scaling_enabled       = bool
    vnet_subnet_id             = string
    max_count                  = number
    min_count                  = number
    orchestrator_version       = string
    node_taints                = list(string)
    os_disk_type               = string
    zones                      = list(string)
    fips_enabled               = bool
    upgrade_settings_max_surge = string
    tags                       = map(string)
  }))

}

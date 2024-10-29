variable "aks_clusters" {
  description = "A map of AKS cluster configurations with related attributes for each cluster."
  type = map(object({
    name                                = string
    location                            = string
    resource_group_name                 = string
    azure_policy_enabled                = bool
    dns_prefix                          = string
    kubernetes_version                  = string
    local_account_disabled              = bool
    node_resource_group                 = string
    oidc_issuer_enabled                 = bool
    private_cluster_enabled             = bool
    private_cluster_public_fqdn_enabled = bool
    role_based_access_control_enabled   = bool
    sku_tier                            = string
    tags                                = map(string)
    workload_identity_enabled           = bool

    default_node_pool_name              = string
    default_node_pool_vm_size           = string
    default_node_pool_node_count        = number
    default_node_pool_min_count         = number
    default_node_pool_max_count         = number
    default_node_pool_enable_auto_scaling = bool
    default_node_pool_type              = string
    default_node_pool_orchestrator_version = string
    default_node_pool_vnet_subnet_id  = string
    default_node_pool_upgrade_settings_max_surge = string

    identity_type                       = string

    network_profile_network_plugin = string
    network_profile_dns_service_ip = string
    network_profile_load_balancer_sku = string
    network_profile_network_policy = string
    network_profile_outbound_type = string
    network_profile_pod_cidr = string
    network_profile_service_cidr = string

  }))
}

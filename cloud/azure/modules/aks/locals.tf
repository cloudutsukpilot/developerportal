locals {
  clusters_list = flatten([for clustername, clusters in var.aks_cluster.aks_clusters :
    {
      name                                     = try(clustername, "${var.global.environment}-${var.global.application}-aks")
      location                                 = try(clusters.location, var.global.location)
      vnet                                = try(clusters.vnet, "${var.global.environment}-${var.global.location}-ApplicationVnet")
      subnet                          = try(clusters.subnet, "${var.global.application}-snet-aks")
      rg                 = try(clusters.rg, "${var.global.environment}-baseNetworkInfrastructure")
      azure_policy_enabled                     = clusters.azure_policy_enabled
      dns_prefix                               = try(clusters.dns_prefix, "${var.global.environment}-${var.global.application}-aks")
      identity_type                            = clusters.identity_type
      kubernetes_version                       = clusters.kubernetes_version
      local_account_disabled                   = clusters.local_account_disabled
      node_resource_group                      = clusters.node_resource_group
      oidc_issuer_enabled                      = clusters.oidc_issuer_enabled
      private_cluster_enabled                  = clusters.private_cluster_enabled
      private_cluster_public_fqdn_enabled      = clusters.private_cluster_public_fqdn_enabled
      role_based_access_control_enabled        = clusters.role_based_access_control_enabled
      rbac_aad_managed                         = clusters.rbac_aad_managed
      rbac_aad_azure_rbac_enabled              = clusters.rbac_aad_azure_rbac_enabled
      rbac_aad_admin_group_object_ids          = clusters.rbac_aad_admin_group_object_ids
      load_balancer_profile_enabled            = clusters.load_balancer_profile_enabled
      network_plugin                           = clusters.network_plugin
      net_profile_dns_service_ip               = clusters.net_profile_dns_service_ip
      load_balancer_sku                        = clusters.load_balancer_sku
      network_policy                           = clusters.network_policy
      net_profile_outbound_type                = clusters.net_profile_outbound_type
      net_profile_pod_cidr                     = clusters.net_profile_pod_cidr
      net_profile_service_cidr                 = clusters.net_profile_service_cidr
      existing_log_analytics_workspace_name    = try(clusters.existing_log_analytics_workspace_name, null)
      existing_log_analytics_workspace_rg_name = try(clusters.existing_log_analytics_workspace_rg_name, null)
      sku_tier                                 = clusters.sku_tier
      workload_identity_enabled                = clusters.workload_identity_enabled
      # data_collection_rule_id                = try(clusters.data_collection_rule_id, "")
      # tags                                   = clusters.tags
      default_node_pool = {
        name                 = clusters.default_node_pool.name
        vnet = clusters.default_node_pool.vnet
        subnet = clusters.default_node_pool.subnet
        vm_size              = clusters.default_node_pool.vm_size
        node_count           = clusters.default_node_pool.node_count
        min_count            = clusters.default_node_pool.min_count
        max_count            = clusters.default_node_pool.max_count
        enable_auto_scaling  = clusters.default_node_pool.enable_auto_scaling
        orchestrator_version = clusters.default_node_pool.orchestrator_version
        vnet_subnet_id       = try(clusters.default_node_pool.vnet_subnet_id, null)
        max_surge = try(clusters.default_node_pool.max_surge, "10%")
      }
  }])

  # allowed_subnet_ids_firewall_rule = concat([for subnet in data.azurerm_subnet.cluster_subnet : subnet.id], [for subnet in data.azurerm_subnet.bastion_subnet : subnet.id]) # first list is of aks_subnet and second is for bastion_subnet
  node_pools = flatten([for clustername, clusters in var.aks_cluster.aks_clusters :
    [for node_pool, nodepooldata in clusters.node_pools : 
      {
        name                        = try(lower(node_pool.name), lower(node_pool))
        # enabled = try(nodepool_data.enabled, false)
        vnet = nodepooldata.vnet
        subnet = nodepooldata.subnet
        cluster                     = clustername
        vm_size                     = nodepooldata.vm_size
        node_count                  = nodepooldata.node_count
        max_pods                    = nodepooldata.max_pods
        node_labels                 = nodepooldata.node_labels
        enable_auto_scaling         = nodepooldata.enable_auto_scaling
        max_count                   = nodepooldata.max_count
        min_count                   = nodepooldata.min_count
        orchestrator_version        = nodepooldata.orchestrator_version
        rg    = clusters.rg
        fips_enabled                = try(nodepooldata.fips_enabled, false)
        node_taints                 = try(nodepooldata.node_taints, [])
        os_disk_type                = try(nodepooldata.os_disk_type, "Managed")
        zones                       = try(nodepooldata.zones, [])
        max_surge = try(nodepooldata.max_surge, "10%")
  } if nodepooldata.enabled == true ]])
  role_assignment_list = flatten([for clustername, clusters in var.aks_cluster.aks_clusters :
    flatten([for objectid in clusters.rbac_aad_admin_group_object_ids :
      {
        clustername = clustername
        objectid    = objectid
    }])
  ])
  # cluster_ids = {
  #     "ops2-1" = "/subscriptions/7824cfc2-3f60-432d-9515-4eed4c969e0b/resourcegroups/alta-preprod/providers/Microsoft.ContainerService/managedClusters/preprod-management-plane",
  #     "ops2-2" = "/subscriptions/7824cfc2-3f60-432d-9515-4eed4c969e0b/resourcegroups/alta-preprod/providers/Microsoft.ContainerService/managedClusters/preprod-management-plane2"
  # }
  tags                             = merge({ "Environment" = format("%s", var.global.environment) }, { "Region" = format("%s", var.global.location) }, var.extra_tags)
}

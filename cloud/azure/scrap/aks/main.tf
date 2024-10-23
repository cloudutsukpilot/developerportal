module "aks_clusters" {
  count                   = try(var.aks_cluster.enabled, true) == true ? 1 : 0
  source                  = "../modules/aks"
  global                  = var.global
  aks_cluster             = var.aks_cluster
  extra_tags              = local.tags
}

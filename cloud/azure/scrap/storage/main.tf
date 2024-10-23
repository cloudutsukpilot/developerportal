module "storage_account" {
  source = "../modules/storage"

  global     = var.global
  extra_tags = var.extra_tags
  storage    = var.storage
  rg         = var.rg
  #location  = var.global.location
  network = var.network
}


module "postfix" {
  source          = "../modules/postfix"

  global          = var.global
  extra_tags      = var.extra_tags
  storage = var.storage
  rg      = var.rg
  postfix  = var.postfix
  network = var.network
}


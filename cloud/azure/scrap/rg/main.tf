module "rg-journaling" {
  source     = "../modules/rg"
  global     = var.global
  rg         = var.rg
  extra_tags = var.extra_tags
}


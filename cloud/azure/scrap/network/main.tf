module "network-asp" {
  count      = try(var.network.enabled, true) == true ? 1 : 0
  source     = "../modules/network"
  rg         = var.rg
  network    = var.network
  global     = var.global
  extra_tags            = local.tags
  bastion_vm_public_key = local.bastion_vm_public_key
  custom_data           = data.template_file.linux-vm-cloud-init.rendered
}


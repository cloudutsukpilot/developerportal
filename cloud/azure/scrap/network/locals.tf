locals {
  tags     = merge({ "Environment" = format("%s", var.global.environment) }, { "Region" = format("%s", var.global.location) }, var.extra_tags)
  bastion_vm_public_key = base64decode(data.sops_file.secrets.data["BASTION_VM_SSH_PUBLIC_KEY"])
}
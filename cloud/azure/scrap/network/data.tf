data "sops_file" "secrets" {
  source_file = "../../../environments/${var.global.environment}/secrets.enc.yaml"
}

data "template_file" "linux-vm-cloud-init" {
  template = file("bin/custom_data.sh")
}
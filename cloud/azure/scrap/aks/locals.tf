locals {
  tags     = merge({ "Environment" = format("%s", var.global.environment) }, { "Region" = format("%s", var.global.location) }, var.extra_tags)
}
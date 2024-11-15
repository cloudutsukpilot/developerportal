resource "azuread_group" "groups" {
    for_each = var.aad_groups

    display_name     = each.value.display_name
    description      = each.value.description
    owners           = lookup(each.value, "owners", data.azuread_client_config.current.object_id)
    members          = each.value.members
    security_enabled = each.value.security_enabled
}
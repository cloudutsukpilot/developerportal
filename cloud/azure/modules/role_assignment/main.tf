resource "azurerm_role_assignment" "role_assignments" {
  for_each             = { for idx, role in var.role_assignments : "${idx}-${role.scope}" => role }

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
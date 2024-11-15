output "aad_group_outputs" {
  description = "The AAD group outputs"
  value = { 
    for aad_group in azuread_group.groups : aad_group.display_name => {
      display_name     = aad_group.display_name
      id       = aad_group.id
    }
  }
}
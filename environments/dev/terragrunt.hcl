include {
  path = find_in_parent_folders()
}


# Resource Group module
terraform {
  source = "../../cloud/azure/modules/resource_group"
}

inputs = {
  resource_groups = {
    "dev-backstage-rg" = "centralindia"
    "dev-test-rg" = "centralindia"
  }
  
  tags = {
    "dev-backstage-rg" = {
      "Owner": "Cloudutsuk",
      "Application": "Backstage",
      "CreatedBy": "Sakharam Shinde"
    }
    "dev-test-rg" = {
      "Owner": "Cloudutsuk",
      "Application": "Test",
      "CreatedBy": "Sakharam Shinde"
    }
  }
}

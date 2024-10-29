output "storage_account_name" {
  description = "The storage account outputs"
  value = {
    for storage_acc in azurerm_storage_account.storage : storage_acc.name => {
      name = storage_acc.name
    }
  }
}
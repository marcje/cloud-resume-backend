resource "azurerm_storage_account" "st" {
  name                       = var.storage_account_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  account_tier               = "Standard"
  account_kind               = "StorageV2"
  account_replication_type   = var.storage_account_replication_type
  https_traffic_only_enabled = true
}

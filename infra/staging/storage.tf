resource "azurerm_storage_account" "st" {
  name                      = var.storage_account_name
  location                  = var.default_location
  resource_group_name       = azurerm_resource_group.rg.name
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = var.storage_account_replication_type
  enable_https_traffic_only = true
}

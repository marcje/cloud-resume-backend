resource "azurerm_cosmosdb_account" "cosacc" {
  name                = "${var.default_prefix}-cosacc"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  enable_free_tier    = true
  
  geo_location {
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 86400
    max_staleness_prefix    = 1000000
  }

  capabilities {
    name = "EnableTable"
  }

  capabilities {
    name = "EnableTable"
  }

  backup {
    type = "Continuous"
  }
}

resource "azurerm_cosmosdb_table" "costab" {
  name                = "visitorCounter"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosacc.name
  throughput          = 400
}

data "azurerm_cosmosdb_account" "cosacc" {
  name                = azurerm_cosmosdb_table.costab.account_name
  resource_group_name = azurerm_cosmosdb_table.costab.resource_group_name
}
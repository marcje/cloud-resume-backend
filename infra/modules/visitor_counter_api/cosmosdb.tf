resource "azurerm_cosmosdb_account" "cosacc" {
  name                = var.cosmosdb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  free_tier_enabled   = true

  geo_location {
    location          = var.location
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
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosacc.name
  throughput          = 400
}

data "azurerm_cosmosdb_account" "cosacc" {
  name                = azurerm_cosmosdb_table.costab.account_name
  resource_group_name = azurerm_cosmosdb_table.costab.resource_group_name
}

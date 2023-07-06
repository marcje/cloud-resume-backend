resource "azurerm_service_plan" "asp" {
  name                = "${var.default_prefix}-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                       = "${var.default_prefix}-func"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  storage_account_name       = azurerm_storage_account.st.name
  storage_account_access_key = azurerm_storage_account.st.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id
  https_only                 = true

  site_config {
    cors {
      allowed_origins = [var.cors_domain]
    }
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    "CORS_ORIGIN" = var.cors_domain
  }

  connection_string {
    name  = "CosmosDbConnectionString"
    type  = "Custom"
    value = "AccountEndpoint=${data.azurerm_cosmosdb_account.cosacc.endpoint};AccountKey=${data.azurerm_cosmosdb_account.cosacc.primary_key};"
  }
}
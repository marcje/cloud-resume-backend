resource "azurerm_service_plan" "asp" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "func" {
  name                       = var.function_app_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  storage_account_name       = azurerm_storage_account.st.name
  storage_account_access_key = azurerm_storage_account.st.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id
  https_only                 = true

  site_config {
    cors {
      allowed_origins = [var.cors_allowed_origins]
    }
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    "CORS_ORIGIN" = var.cors_allowed_origins
  }

  connection_string {
    name  = "CosmosDbConnectionString"
    type  = "Custom"
    value = "AccountEndpoint=${data.azurerm_cosmosdb_account.cosacc.endpoint};AccountKey=${data.azurerm_cosmosdb_account.cosacc.primary_key};"
  }
}

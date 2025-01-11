resource "azurerm_resource_group" "rg" {
  name     = "${var.default_prefix}-rg"
  location = var.default_location
}

resource "azurerm_consumption_budget_resource_group" "resource-group-budget" {
  name              = "low-budget"
  resource_group_id = azurerm_resource_group.rg.id
  amount            = var.resource_group_budget_amount
  time_grain        = var.resource_group_budget_time

  time_period {
    start_date = var.resource_group_budget_start
    end_date   = var.resource_group_budget_end
  }

  notification {
    enabled        = true
    threshold      = var.resource_group_budget_actual_threshold
    threshold_type = "Actual"
    operator       = "GreaterThan"
    contact_emails = var.resource_group_budget_contact_emails
  }

  notification {
    enabled        = true
    threshold      = var.resource_group_budget_forecast_threshold
    threshold_type = "Forecasted"
    operator       = "EqualTo"
    contact_emails = var.resource_group_budget_contact_emails
  }
}

module "visitor_counter_api" {
  source                           = "../modules/visitor_counter_api"
  resource_group_name              = azurerm_resource_group.rg.name
  location                         = azurerm_resource_group.rg.location
  storage_account_name             = "${replace(var.default_prefix, "-", "")}st"
  storage_account_replication_type = var.storage_account_replication_type
  cosmosdb_name                    = "${var.default_prefix}-cosacc"
  service_plan_name                = "${var.default_prefix}-asp"
  function_app_name                = "${var.default_prefix}-func"
  cors_allowed_origins             = var.cors_domain
}


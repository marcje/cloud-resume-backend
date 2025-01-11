variable "resource_group_name" {
  type        = string
  description = "Azure resource group to contain resources"
}

variable "location" {
  type        = string
  description = "Region to deploy resources in"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"
}

variable "storage_account_replication_type" {
  type        = string
  description = "Storage account replication type"
}

variable "cosmosdb_name" {
  type        = string
  description = "Name of the CosmosDB"
}

variable "service_plan_name" {
  type        = string
  description = "Name of the service plan"
}

variable "function_app_name" {
  type        = string
  description = "Name of the function app"
}

variable "cors_allowed_origins" {
  type        = string # TODO: change to list
  description = "Allowed domains for CORS headers"
}

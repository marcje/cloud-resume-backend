variable "default_location" {
  type        = string
  description = "Default location for resources."
  default     = "westeurope"
}

variable "default_prefix" {
  type        = string
  description = "Default prefix for resources."
}

variable "resource_group_budget_amount" {
  type        = string
  description = "Resource group budget amount"
}

variable "resource_group_budget_time" {
  type        = string
  description = "Resource group budget time grain"
  default     = "Monthly"
}

variable "resource_group_budget_contact_emails" {
  type        = list(string)
  sensitive   = true
  description = "Resource group budget contact emails"
}

variable "resource_group_budget_start" {
  type        = string
  description = "Resource group budget start date"
}

variable "resource_group_budget_end" {
  type        = string
  description = "Resource group budget end date"
}

variable "resource_group_budget_actual_threshold" {
  type        = string
  description = "Resource group budget - percentage to notify on actual reached threshold"
}

variable "resource_group_budget_forecast_threshold" {
  type        = string
  description = "Resource group budget - percentage to notify on forecasted threshold"
}

variable "storage_account_replication_type" {
  type        = string
  description = "Storage account replication type"
}

variable "cors_domain" {
  type        = string
  description = "CORS origin allowed domain"
}

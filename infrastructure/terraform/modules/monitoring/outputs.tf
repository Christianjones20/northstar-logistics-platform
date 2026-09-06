# --------------------------------------------------
# LOG ANALYTICS WORKSPACE
# --------------------------------------------------

output "log_analytics_workspace_id" {
  description = "The resource ID of the NorthStar Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.northstar.id
}

output "log_analytics_workspace_name" {
  description = "The name of the NorthStar Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.northstar.name
}

output "log_analytics_workspace_workspace_id" {
  description = "The workspace/customer ID of the NorthStar Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.northstar.workspace_id
}
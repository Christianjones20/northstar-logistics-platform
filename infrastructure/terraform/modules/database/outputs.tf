output "postgres_server_id" {
  description = "PostgreSQL Flexible Server resource ID"
  value       = azurerm_postgresql_flexible_server.northstar.id
}

output "postgres_server_name" {
  description = "PostgreSQL Flexible Server name"
  value       = azurerm_postgresql_flexible_server.northstar.name
}

output "postgres_fqdn" {
  description = "PostgreSQL Flexible Server hostname"
  value       = azurerm_postgresql_flexible_server.northstar.fqdn
}

output "postgres_database_name" {
  description = "NorthStar PostgreSQL database name"
  value       = azurerm_postgresql_flexible_server_database.northstar.name
}

output "private_dns_zone_id" {
  description = "PostgreSQL private DNS zone ID"
  value       = azurerm_private_dns_zone.postgres.id
}
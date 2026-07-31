output "bigtable_backups" {
  value       = module.bigtable_backups
  description = "All outputs from the bigtable_backups module, including the Cloud Run job, scheduler, and service account emails."
  sensitive   = true
}

output "job" {
  value       = google_cloud_run_v2_job.default
  description = "The Cloud Run v2 backup job."
}

output "scheduler" {
  value       = google_cloud_scheduler_job.backup
  description = "The Cloud Scheduler job that triggers the backup."
}

output "backup_job_service_account_email" {
  value       = google_service_account.backup_job.email
  description = "Email of the service account the Cloud Run job runs as. Grant it Bigtable backup permissions on the relevant instance."
}

output "scheduler_invoker_service_account_email" {
  value       = google_service_account.scheduler_invoker.email
  description = "Email of the service account Cloud Scheduler uses to invoke the job."
}

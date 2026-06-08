resource "google_service_account" "backup_job" {
  project      = var.project_id
  account_id   = "${var.job_name}-job"
  display_name = "Service account for ${var.job_name} Cloud Run backup job"
}

resource "google_service_account" "scheduler_invoker" {
  project      = var.project_id
  account_id   = "${var.job_name}-sch"
  display_name = "Service account for Cloud Scheduler invoking ${var.job_name}"
}

resource "google_cloud_run_v2_job_iam_member" "scheduler_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_job.default.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.scheduler_invoker.email}"
}

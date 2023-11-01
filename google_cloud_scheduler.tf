resource "google_cloud_scheduler_job" "backup" {
  name             = "backup-scheduler-trigger"
  attempt_deadline = "180s"
  description      = "backup scheduler"
  schedule         = var.schedule

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${var.job_name}:run"

    oauth_token {
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
      service_account_email = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
    }
  }

  retry_config {
    max_backoff_duration = "3600s"
    max_doublings        = 5
    max_retry_duration   = "0s"
    min_backoff_duration = "5s"
    retry_count          = 0
  }
  region = var.region

  depends_on = [google_cloud_run_v2_job.default]
}

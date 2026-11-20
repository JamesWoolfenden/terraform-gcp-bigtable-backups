resource "google_cloud_scheduler_job" "backup" {
  project          = var.project_id
  region           = var.region
  name             = "${var.job_name}-scheduler"
  attempt_deadline = "180s"
  description      = "backup scheduler"
  schedule         = var.schedule

  http_target {
    http_method = "POST"
    # Cloud Run Admin API endpoint that starts a job execution.
    uri = "https://${google_cloud_run_v2_job.default.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${google_cloud_run_v2_job.default.project}/jobs/${google_cloud_run_v2_job.default.name}:run"

    # *.googleapis.com endpoints only accept OAuth 2.0 access tokens; an OIDC
    # ID token is rejected with 401, so the job would never run.
    oauth_token {
      service_account_email = google_service_account.scheduler_invoker.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }

  retry_config {
    max_backoff_duration = "3600s"
    max_doublings        = 5
    max_retry_duration   = "0s"
    min_backoff_duration = "5s"
    retry_count          = 3
  }

  depends_on = [google_cloud_run_v2_job_iam_member.scheduler_invoker]
}

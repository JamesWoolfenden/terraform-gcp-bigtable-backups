# holden:ignore:HLD_GCP_176 — vpc_access is optional; callers without a VPC connector use Google's private network for Bigtable access
resource "google_cloud_run_v2_job" "default" {
  name     = var.job_name
  location = var.region
  client   = "cloud-console"

  template {
    template {
      service_account = google_service_account.backup_job.email

      dynamic "vpc_access" {
        for_each = var.vpc_access != null ? [var.vpc_access] : []
        content {
          connector = vpc_access.value.connector
          egress    = vpc_access.value.egress
        }
      }

      containers {
        image = var.image
        env {
          name  = "project"
          value = var.project_id
        }
        resources {
          limits = {
            "cpu"    = "1000m"
            "memory" = "512Mi"
          }
        }
      }
    }
  }

  labels = var.labels

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
}

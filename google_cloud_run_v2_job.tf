resource "google_cloud_run_v2_job" "default" {
  name     = var.job_name
  location = var.region
  client   = "cloud-console"

  template {
    template {
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

# holden:ignore:HLD_GCP_176 — vpc_access is optional; callers without a VPC connector use Google's private network for Bigtable access
resource "google_cloud_run_v2_job" "default" {
  project  = var.project_id
  name     = var.job_name
  location = var.region

  template {
    template {
      service_account = google_service_account.backup_job.email
      timeout         = var.timeout

      # Use customer-managed encryption key (CMEK) for container instances
      encryption_key = var.encryption_key

      dynamic "vpc_access" {
        for_each = local.vpc_access
        content {
          connector = vpc_access.value.connector
          egress    = vpc_access.value.egress
        }
      }

      containers {
        # Image must be pinned by digest (image@sha256:<64-hex>) for Cloud Run v2
        image = var.image
        dynamic "env" {
          for_each = local.container_env
          content {
            name  = env.key
            value = env.value
          }
        }

        resources {
          limits = {
            "cpu"    = var.cpu
            "memory" = var.memory
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }

  depends_on = [google_kms_crypto_key_iam_member.cloud_run_cmek]
}

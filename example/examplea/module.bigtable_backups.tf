# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "bigtable_backups" {
  source = "../../"
  # build and replacedepends_on your own container based on the folder gcloud-container
  # should use sha version rather than nikovirtala/whalesay
  image          = "nikovirtala/whalesay:3000@sha256:cc4a18f9bd762d7614cb2a415652484fdc6b4cda00354399f9e5768734c8e443"
  job_name       = "backup"
  schedule       = "0 9 * * 1"
  region         = "us-central1"
  project_id     = "pike-477416"
  encryption_key = google_kms_crypto_key.backups.id
}


resource "google_kms_key_ring" "backups" {
  name     = "backups-key-ring"
  location = "us-central1"
}


resource "google_kms_crypto_key" "backups" {
  name                       = "backups-key"
  key_ring                   = google_kms_key_ring.backups.id
  rotation_period            = "7776000s" # 90 days; GCP requires > 24h (86400s)
  destroy_scheduled_duration = "604800s"  # 7 days; GCP minimum is 7 days

  lifecycle {
    prevent_destroy = true
  }
}

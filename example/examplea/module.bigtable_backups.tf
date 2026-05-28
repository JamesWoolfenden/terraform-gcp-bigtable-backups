# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "bigtable_backups" {
  source   = "../../"
  image    = "us-central1-docker.pkg.dev/pike-477416/pike/backup:latest"
  job_name = "backup"
  schedule = "0 9 * * 1"
  labels = {
    pike = "permissions"
  }
  region     = "us-central1"
  project_id = "pike-477416"
}

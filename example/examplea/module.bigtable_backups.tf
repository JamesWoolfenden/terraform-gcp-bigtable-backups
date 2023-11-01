module "bigtable_backups" {
  source   = "../../"
  image    = "us-central1-docker.pkg.dev/pike-gcp/pike/backup:latest"
  job_name = "backup"
  schedule = "0 9 * * 1"
  labels = {
    pike = "permissions"
  }
  region     = "us-central1"
  project_id = "pike-gcp"
}

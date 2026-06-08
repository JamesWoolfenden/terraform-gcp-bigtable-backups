# holden:ignore:HLD_GCP_059 — per-repo WIF SA with attribute.repository scoping
# provides equivalent least-privilege without impersonation.
provider "google" {
  default_labels = {
    environment = "prod"
    team        = "security"
    managed_by  = "terraform"
  }
}

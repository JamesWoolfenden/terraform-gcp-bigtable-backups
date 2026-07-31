# holden:ignore:HLD_TF_004 — this is a reusable module, not a root config; the backend is the caller's concern
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.42.0"
    }
  }
}

# Cloud Run does not automatically gain access to a caller-supplied CMEK: the
# Cloud Run service agent must hold cryptoKeyEncrypterDecrypter on the key
# before the job can be created or executed.
# https://cloud.google.com/run/docs/securing/using-cmek
resource "google_kms_crypto_key_iam_member" "cloud_run_cmek" {
  crypto_key_id = var.encryption_key
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.current.number}@serverless-robot-prod.iam.gserviceaccount.com"
}

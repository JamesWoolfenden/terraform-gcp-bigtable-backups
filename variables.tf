variable "region" {
  type        = string
  description = "GCP region in which the Cloud Run job and Cloud Scheduler job are created, e.g. \"us-central1\"."

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]+$", var.region))
    error_message = "region must be a valid GCP region name, e.g. \"us-central1\" or \"europe-west1\"."
  }
}

variable "project_id" {
  type        = string
  description = "GCP project ID in which all resources are created."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid GCP project ID: 6-30 characters, lowercase letters, digits or hyphens, starting with a letter and not ending with a hyphen."
  }
}


variable "image" {
  type        = string
  description = "Container image for the backup job, pinned by digest (preferred), e.g. \"us-central1-docker.pkg.dev/my-project/my-repo/backup@sha256:<64-hex>\", or by an explicit non-latest tag, e.g. \"...backup:v1.0.0\". Untagged references resolve to :latest and are rejected."

  validation {
    condition     = can(regex("@sha256:[a-f0-9]{64}$", var.image)) || (can(regex(":[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$", element(split("/", var.image), length(split("/", var.image)) - 1))) && !endswith(var.image, ":latest"))
    error_message = "image must be pinned by digest (@sha256:<64-hex>) or carry an explicit tag other than :latest; untagged references resolve to the mutable :latest tag."
  }
}

variable "job_name" {
  type        = string
  description = "Name of the Cloud Run v2 job. Used as a prefix for derived resource names (service accounts). Must be 2-26 characters, lowercase letters, digits or hyphens, starting with a letter and ending with a letter or digit."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,24}[a-z0-9]$", var.job_name))
    error_message = "job_name must be 2-26 characters, start with a lowercase letter, end with a letter or digit, and contain only lowercase letters, digits or hyphens (the derived service account IDs need at least 6 characters)."
  }
}

variable "vpc_access" {
  type = object({
    connector = string
    egress    = optional(string, "ALL_TRAFFIC")
  })
  description = "VPC Access connector configuration for the Cloud Run job. Set connector to a VPC Access Connector resource ID (e.g. projects/PROJECT/locations/REGION/connectors/NAME) to route job traffic through your VPC. Recommended for production workloads where Bigtable is accessed via Private Service Connect or VPC Service Controls."
  default     = null

  validation {
    condition     = var.vpc_access == null || length(trimspace(var.vpc_access.connector)) > 0
    error_message = "vpc_access.connector must not be empty when vpc_access is set."
  }
}

variable "schedule" {
  type        = string
  description = "Cron schedule expression for how often to trigger the backup job (e.g. weekly on Mondays at 09:00 UTC)."

  validation {
    condition     = length(trimspace(var.schedule)) > 0
    error_message = "schedule must not be empty."
  }
}

variable "timeout" {
  type        = string
  description = "Execution timeout for the backup job, e.g. \"3600s\". Cloud Run Jobs default to 600s if unset, which may be too short for large Bigtable backups; raise it further for larger tables (max 24h)."
  default     = "3600s"

  validation {
    condition     = can(regex("^[0-9]+s$", var.timeout))
    error_message = "timeout must be a duration string in seconds, e.g. \"3600s\"."
  }
}

variable "encryption_key" {
  type        = string
  description = "Customer-managed encryption key (CMEK) resource name for the job's container instances, e.g. projects/my-project/locations/us-central1/keyRings/my-kr/cryptoKeys/my-key. The module grants the Cloud Run service agent roles/cloudkms.cryptoKeyEncrypterDecrypter on this key."

  validation {
    condition     = can(regex("^projects/[^/]+/locations/[^/]+/keyRings/[^/]+/cryptoKeys/[^/]+$", var.encryption_key))
    error_message = "encryption_key must be a full KMS key resource name: projects/PROJECT/locations/LOCATION/keyRings/RING/cryptoKeys/KEY."
  }
}

variable "cpu" {
  type        = string
  description = "CPU limit for the backup job container, e.g. \"1000m\" or \"2\"."
  default     = "1000m"

  validation {
    condition     = can(regex("^([0-9]+m|[0-9]+(\\.[0-9]+)?)$", var.cpu))
    error_message = "cpu must be a Kubernetes-style CPU quantity, e.g. \"1000m\", \"1\" or \"2\"."
  }
}

variable "memory" {
  type        = string
  description = "Memory limit for the backup job container, e.g. \"512Mi\" or \"1Gi\"."
  default     = "512Mi"

  validation {
    condition     = can(regex("^[0-9]+(Mi|Gi)$", var.memory))
    error_message = "memory must be a quantity in Mi or Gi, e.g. \"512Mi\" or \"1Gi\"."
  }
}

variable "environment_variables" {
  type        = map(string)
  description = "Extra environment variables for the backup container, e.g. { BIGTABLE_INSTANCE = \"my-instance\", BIGTABLE_CLUSTER = \"my-cluster\", BIGTABLE_TABLE = \"my-table\" } for the bundled gcloud-container script. Do not put secrets here; values are stored in plain text in the job spec and state."
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.environment_variables) : can(regex("^[A-Za-z_][A-Za-z0-9_]*$", k)) && k != "project"])
    error_message = "environment_variables keys must be valid environment variable names and must not be \"project\" (set by the module)."
  }
}

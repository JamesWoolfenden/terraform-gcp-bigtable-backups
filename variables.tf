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

variable "labels" {
  type        = map(string)
  description = "Labels to apply to all created resources."

  validation {
    condition     = alltrue([for k in keys(var.labels) : can(regex("^[a-z][a-z0-9_-]{0,62}$", k))])
    error_message = "Label keys must start with a lowercase letter and contain only lowercase letters, digits, hyphens or underscores, up to 63 characters."
  }
}

variable "image" {
  type        = string
  description = "Container image URL for the backup job, e.g. \"us-central1-docker.pkg.dev/my-project/my-repo/backup:v1.0.0\"."

  validation {
    condition     = length(trimspace(var.image)) > 0 && !endswith(var.image, ":latest")
    error_message = "image must not be empty and must not use the mutable :latest tag — pin to a specific version tag or digest."
  }
}

variable "job_name" {
  type        = string
  description = "Name of the Cloud Run v2 job. Used as a prefix for derived resource names (service accounts). Must be 1-26 characters, lowercase letters, digits or hyphens, starting with a letter."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,25}$", var.job_name))
    error_message = "job_name must be 1-26 characters, start with a lowercase letter, and contain only lowercase letters, digits or hyphens."
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

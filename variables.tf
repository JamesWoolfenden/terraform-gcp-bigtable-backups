variable "region" {
  type        = string
  description = "region where the resource is to be created"
}

variable "project_id" {
  type        = string
  description = "Project ID where the resource is to be setup"
}

variable "labels" {
  type        = map(any)
  description = "The labels"
}

variable "image" {
  type        = string
  description = "container image"
}

variable "job_name" {
  type = string
}

variable "schedule" {
  type = string
}

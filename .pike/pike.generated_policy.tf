
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "cloudscheduler.jobs.create",
    "cloudscheduler.jobs.delete",
    "cloudscheduler.jobs.enable",
    "cloudscheduler.jobs.get",
    "cloudscheduler.jobs.update",
    "resourcemanager.projects.get",
    "run.jobs.create",
    "run.jobs.delete",
    "run.jobs.get",
    "run.jobs.update",
    "run.operations.get"
  ]
}

# terraform-gcp-bigtable-backups

[![Build Status](https://github.com/JamesWoolfenden/terraform-gcp-bigtable-backups/workflows/Verify/badge.svg?branch=main)](https://github.com/JamesWoolfenden/terraform-gcp-bigtable-backups)
[![Latest Release](https://img.shields.io/github/release/JamesWoolfenden/terraform-gcp-bigtable-backups.svg)](https://github.com/JamesWoolfenden/terraform-gcp-bigtable-backups/releases/latest)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/JamesWoolfenden/terraform-gcp-bigtable-backups.svg?label=latest)](https://github.com/JamesWoolfenden/terraform-gcp-bigtable-backups/releases/latest)
![Terraform Version](https://img.shields.io/badge/tf-%3E%3D0.14.0-blue.svg)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![checkov](https://img.shields.io/badge/checkov-verified-brightgreen)](https://www.checkov.io/)

## Usage

This module requires a precursor, a prebuilt cloud build container in artifact repository.
Follow the readme build instructions in gcloud-container folder **FIRST**.

Add **module.bigtable-backups.tf** to your code:-

```terraform
module "bigtable-backups" {
  source             = "JamesWoolfenden/bigtable-backups/gcp"
  version            = "0.0.1"
  image              = "us-central1-docker.pkg.dev/pike-477416/pike/backup:latest"
  job_name           = "backup"
  schedule           = "0 9 * * 1"
  labels={
    pike="permissions"
  }
  region            = "us-central1"
  project_id        = "pike-477416"
}
```

## Auth

```bash
gcloud auth application-default login --project yourproj
```

```bash
gcloud builds submit --region=us-central1 --config cloudbuild.yaml --project yourproj
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 7.42.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | 7.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [google_cloud_run_v2_job.default](https://registry.terraform.io/providers/hashicorp/google/7.42.0/docs/resources/cloud_run_v2_job) | resource |
| [google_cloud_run_v2_job_iam_member.scheduler_invoker](https://registry.terraform.io/providers/hashicorp/google/7.42.0/docs/resources/cloud_run_v2_job_iam_member) | resource |
| [google_cloud_scheduler_job.backup](https://registry.terraform.io/providers/hashicorp/google/7.42.0/docs/resources/cloud_scheduler_job) | resource |
| [google_kms_crypto_key_iam_member.cloud_run_cmek](https://registry.terraform.io/providers/hashicorp/google/7.42.0/docs/resources/kms_crypto_key_iam_member) | resource |
| [google_service_account.backup_job](https://registry.terraform.io/providers/hashicorp/google/7.42.0/docs/resources/service_account) | resource |
| [google_service_account.scheduler_invoker](https://registry.terraform.io/providers/hashicorp/google/7.42.0/docs/resources/service_account) | resource |
| [google_project.current](https://registry.terraform.io/providers/hashicorp/google/7.42.0/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_encryption_key"></a> [encryption\_key](#input\_encryption\_key) | Customer-managed encryption key (CMEK) resource name, e.g. projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key | `string` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | Container image URL for the backup job, e.g. "us-central1-docker.pkg.dev/my-project/my-repo/backup:v1.0.0". | `string` | n/a | yes |
| <a name="input_job_name"></a> [job\_name](#input\_job\_name) | Name of the Cloud Run v2 job. Used as a prefix for derived resource names (service accounts). Must be 1-26 characters, lowercase letters, digits or hyphens, starting with a letter. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID in which all resources are created. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region in which the Cloud Run job and Cloud Scheduler job are created, e.g. "us-central1". | `string` | n/a | yes |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | Cron schedule expression for how often to trigger the backup job (e.g. weekly on Mondays at 09:00 UTC). | `string` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Execution timeout for the backup job, e.g. "3600s". Cloud Run Jobs default to 600s if unset, which may be too short for large Bigtable backups; raise it further for larger tables (max 24h). | `string` | `"3600s"` | no |
| <a name="input_vpc_access"></a> [vpc\_access](#input\_vpc\_access) | VPC Access connector configuration for the Cloud Run job. Set connector to a VPC Access Connector resource ID (e.g. projects/PROJECT/locations/REGION/connectors/NAME) to route job traffic through your VPC. Recommended for production workloads where Bigtable is accessed via Private Service Connect or VPC Service Controls. | <pre>object({<br/>    connector = string<br/>    egress    = optional(string, "ALL_TRAFFIC")<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backup_job_service_account_email"></a> [backup\_job\_service\_account\_email](#output\_backup\_job\_service\_account\_email) | Email of the service account the Cloud Run job runs as. Grant it Bigtable backup permissions on the relevant instance. |
| <a name="output_job"></a> [job](#output\_job) | The Cloud Run v2 backup job. |
| <a name="output_scheduler"></a> [scheduler](#output\_scheduler) | The Cloud Scheduler job that triggers the backup. |
| <a name="output_scheduler_invoker_service_account_email"></a> [scheduler\_invoker\_service\_account\_email](#output\_scheduler\_invoker\_service\_account\_email) | Email of the service account Cloud Scheduler uses to invoke the job. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Information

<!-- BEGINNING OF PRE-COMMIT-PIKE DOCS HOOK -->
The Terraform resource required is:

```golang
# apply role
resource "google_project_iam_custom_role" "terraform_pike" {
  project     = "pike-477416"
  role_id     = "terraform_pike"
  title       = "terraform_pike"
  description = "A user with least privileges"
  permissions = [
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudkms.cryptoKeys.setIamPolicy",
    "cloudscheduler.jobs.create",
    "cloudscheduler.jobs.delete",
    "cloudscheduler.jobs.enable",
    "cloudscheduler.jobs.get",
    "cloudscheduler.jobs.update",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.update",
    "resourcemanager.projects.get",
    "run.jobs.create",
    "run.jobs.delete",
    "run.jobs.get",
    "run.jobs.getIamPolicy",
    "run.jobs.setIamPolicy",
    "run.jobs.update",
    "run.operations.get"
  ]
}

# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = "pike-477416"
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudscheduler.jobs.get",
    "iam.serviceAccounts.get",
    "resourcemanager.organizations.get",
    "resourcemanager.projects.get",
    "run.jobs.get",
    "run.jobs.getIamPolicy",
    "run.operations.get"
  ]
}


```
<!-- END OF PRE-COMMIT-PIKE DOCS HOOK -->

## Related Projects

Check out these related projects.

- [terraform-aws-codecommit](https://github.com/jameswoolfenden/terraform-aws-codebuild) - Storing ones code

## Help

**Got a question?**

File a GitHub [issue](https://github.com/jameswoolfenden/terraform-aws-bigquery/issues).

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/jameswoolfenden/terraform-aws-bigquery/issues) to report any bugs or file feature requests.

## Copyrights

Copyright � 2026 James Woolfenden

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements. See the NOTICE file
distributed with this work for additional information
regarding copyright ownership. The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied. See the License for the
specific language governing permissions and limitations
under the License.

### Contributors

[![James Woolfenden][jameswoolfenden_avatar]][jameswoolfenden_homepage]<br/>[James Woolfenden][jameswoolfenden_homepage]

[jameswoolfenden_homepage]: https://github.com/jameswoolfenden
[jameswoolfenden_avatar]: https://github.com/jameswoolfenden.png?size=150

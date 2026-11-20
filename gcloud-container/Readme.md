# update scripts

Update your script.sh with **your** gcloud commands, or configure the bundled
backup script through the module's `environment_variables` input:

```hcl
environment_variables = {
  BIGTABLE_INSTANCE = "my-instance"
  BIGTABLE_CLUSTER  = "my-cluster"
  BIGTABLE_TABLE    = "my-table"
  BACKUP_RETENTION  = "7d"
}
```

The job's service account (output `backup_job_service_account_email`) needs
`bigtable.backups.create` on the instance (and `bigtable.tables.get` on the
table), e.g. via a custom role or `roles/bigtable.admin`.

## Set Auth

```bash
gcloud auth application-default login --project <yourproj>
```

## Build your container

```bash
gcloud artifacts repositories create pike --location=us-central1 --project <yourproj>
gcloud builds submit --region=us-central1 --config cloudbuild.yaml --project <yourproj>
```

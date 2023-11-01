# update scripts

Update your scripts.sh with **your** gcloud commands.

## Set Auth

```bash
gcloud auth application-default login --project <yourproj>
```

## Build your container

```bash
gcloud artifacts repositories create pike --location=us-central1 --project <yourproj>
gcloud builds submit --region=us-central1 --config cloudbuild.yaml --project <yourproj>
```

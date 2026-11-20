#!/usr/bin/env bash
##
# script.sh
# Creates an on-demand Cloud Bigtable backup. Edit to suit, or drive it entirely
# through environment variables set on the Cloud Run job (the module's
# environment_variables input):
#
#   project              GCP project (set by the module; or pass as $1)
#   BIGTABLE_INSTANCE    Bigtable instance ID (required)
#   BIGTABLE_CLUSTER     Bigtable cluster ID (required)
#   BIGTABLE_TABLE       Table to back up (required)
#   BACKUP_RETENTION     Retention period, default 7d
##
set -euo pipefail

PROJECT="${1:-${project:-}}"
: "${PROJECT:?project must be set via the project env var or as the first argument}"
: "${BIGTABLE_INSTANCE:?BIGTABLE_INSTANCE must be set}"
: "${BIGTABLE_CLUSTER:?BIGTABLE_CLUSTER must be set}"
: "${BIGTABLE_TABLE:?BIGTABLE_TABLE must be set}"
RETENTION="${BACKUP_RETENTION:-7d}"

# Timestamped, sortable and unique per run; table prefix truncated to keep the
# ID within Bigtable's 50-character limit.
BACKUP_ID="${BIGTABLE_TABLE:0:30}-$(date -u +%Y%m%d-%H%M%S)"

gcloud bigtable backups create "${BACKUP_ID}" \
  --instance="${BIGTABLE_INSTANCE}" \
  --cluster="${BIGTABLE_CLUSTER}" \
  --table="${BIGTABLE_TABLE}" \
  --retention-period="${RETENTION}" \
  --project "${PROJECT}"

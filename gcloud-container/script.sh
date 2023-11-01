#!/usr/bin/env bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##
# script.sh
# Uses gcloud to create a report of Cloud Run services.
# Uses gsutil to write the report to Cloud Storage.
#
# Requires GCLOUD_REPORT_BUCKET environment variable
##

# [START cloudrun_report_script]
set -eo pipefail


# Write a report containing the service name, service URL, service account or user that
# deployed it, and any explicitly configured service "limits" such as CPU or Memory.
gcloud bigtable backups create $RANDOM --instance=yourinstance --cluster=yourcluster --table=example --retention-period=7d --project "$1"

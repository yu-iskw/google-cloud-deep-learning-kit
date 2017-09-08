#!/bin/bash
set -e

INSTANCE_NAME=$1
GCP_PROJECT_ID=$2
GCP_ZONE=$3
COMMAND=$4

gcloud compute ssh ${INSTANCE_NAME} \
  --project ${GCP_PROJECT_ID} \
  --zone ${GCP_ZONE} \
  --ssh-flag='-ServerAliveInterval=60' \
  --ssh-flag='-ServerAliveCountMax=1440' \
  --command="${COMMAND}"

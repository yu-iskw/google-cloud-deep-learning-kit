#!/bin/bash
set -e

INSTANCE_NAME=$1
GCP_PROJECT_ID=$2
GCP_ZONE=$3       # us-east1-d
MACHINE_TYPE=$4   # n1-standard-4
BOOT_DISK_SIZE=$5 # 100GB
SCOPES=$6         # default,bigquery,cloud-platfor,storage-rw

gcloud beta compute instances create $INSTANCE_NAME \
   --project $GCP_PROJECT_ID \
    --zone $GCP_ZONE \
    --machine-type $MACHINE_TYPE \
    --min-cpu-platform "Intel Broadwell" \
    --boot-disk-size ${BOOT_DISK_SIZE} \
    --boot-disk-auto-delete \
    --boot-disk-type=pd-ssd \
    --image ubuntu-1604-xenial-v20170307 \
    --image-project ubuntu-os-cloud \
    --maintenance-policy TERMINATE \
    --restart-on-failure \
    --scopes "${SCOPES}" \
    --metadata startup-script='#!/bin/bash
    # Make a directory to store source files
    mkdir -p /src && chmod 777 /src
    mkdir -p /src/outputs && chmod 777 /src/outputs

    sudo apt-get update
    sudo apt-get install -y wget linux-headers-$(uname -r) gcc make g++

    # install docker
    # https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#set-up-the-repository
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce

    # Pull a docker image
    echo "Start pulling a docker image" >> /src/startup-script.log
    sudo docker pull yuiskw/google-cloud-deep-learning-kit:tf-1.5-cpu
    echo "End pulling a docker image" >> /src/startup-script.log

    # Run docker
    #echo "Start launching a docker container" >> /src/startup-script.log
    #sudo nvidia-docker run -it --rm -d -v /src:/src -p 8888:8888 --name jupyter yuiskw/google-cloud-deep-learning-kit
    echo "Startup script has done !!" >> /src/startup-script.log
    '

#!/bin/bash
set -e

INSTANCE_NAME=$1
GCP_PROJECT_ID=$2
GCP_ZONE=$3       # us-east1-d
MACHINE_TYPE=$4   # n1-standard-4
ACCELERATOR=$5    # 'type=nvidia-tesla-k80,count=1'
BOOT_DISK_SIZE=$6 # 100GB
SCOPES=$7         # default,bigquery,cloud-platfor,storage-rw

gcloud beta compute instances create $INSTANCE_NAME \
   --project $GCP_PROJECT_ID \
    --zone $GCP_ZONE \
    --machine-type $MACHINE_TYPE \
    --min-cpu-platform "Intel Broadwell" \
    --accelerator $ACCELERATOR \
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

    # Install nvidia-docker
    sudo apt-get update
    sudo apt-get install -y wget linux-headers-$(uname -r) gcc make g++

    wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
    sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
    sudo apt-get update
    sudo apt-get install -y cuda
    export PATH=$PATH:/usr/local/cuda/bin
    sudo curl -fsSL https://get.docker.com/ | sh
    sudo curl -fsSL https://get.docker.com/gpg | sudo apt-key add -
    wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
    sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

    # Pull a docker image
    echo "Start pulling a docker image" >> /src/startup-script.log
    sudo docker pull yuiskw/google-cloud-deep-learning-kit:latest
    echo "End pulling a docker image" >> /src/startup-script.log

    # Run docker
    #echo "Start launching a docker container" >> /src/startup-script.log
    #sudo nvidia-docker run -it --rm -d -v /src:/src -p 8888:8888 --name jupyter yuiskw/google-cloud-deep-learning-kit
    echo "Startup script has done !!" >> /src/startup-script.log
    '

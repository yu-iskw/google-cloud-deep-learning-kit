#!/bin/bash

gcloud beta compute instances create gpu-instance-1 \
    --machine-type n1-standard-2 --zone us-east1-d \
    --accelerator type=nvidia-tesla-k80,count=1 \
    --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud \
    --maintenance-policy TERMINATE --restart-on-failure \
    --metadata startup-script='#!/bin/bash
    echo "Checking for CUDA and installing."
    # Check for CUDA and try to install.
    if ! dpkg-query -W cuda; then
      curl -O http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
      dpkg -i ./cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
      apt-get update
      apt-get install cuda -y
    fi

    LANG=C.UTF-8 LC_ALL=C.UTF-8
    ANACONDA_INSTALLER https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
    apt-get update --fix-missing
    apt-get install -y --no-install-recommends apt-utils
    apt-get install -y wget bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 git curl grep sed dpkg
    wget --quiet ${ANACONDA_INSTALLER} -O ~/anaconda.sh
    /bin/bash ~/anaconda.sh -b -p /opt/conda
    rm ~/anaconda.sh
    apt-get clean
    PATH="/opt/conda/bin:$PATH"

    CONDA_ENV_NAME='konica'
    conda create -y -n ${CONDA_ENV_NAME} python=3.5
    conda install -y libgfortran
    PATH="/opt/conda/envs/${CONDA_ENV_NAME}/bin:$PATH"
    pip install -U numpy \
      scikit-learn \
      matplotlib \
      jupyter \
      jupyter_contrib_nbextensions \
      tensorflow-gpu==1.2.0 \
      keras==2.0.4

    echo 'PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc &&\
    echo 'PATH=/opt/conda/envs/${CONDA_ENV_NAME}:/opt/conda/bin:$PATH' >> ~/.bashrc &&\

    reboot
    '

FROM nvidia/cuda:8.0-cudnn5-runtime-ubuntu16.04

MAINTAINER yu-iskw

# Pick up some TF dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        libgtk2.0-0 \
        git \
        tcl-dev \
        tk-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh \
      && bash Miniconda-latest-Linux-x86_64.sh -p /miniconda -b \
      && rm Miniconda-latest-Linux-x86_64.sh
ENV PATH /miniconda/bin:$PATH

# Create a conda environment
COPY environment-gpu.yml  ./environment.yml
RUN conda env create -f environment.yml -n jupyter-keras-gpu
ENV PATH /miniconda/envs/jupyter-keras-gpu/bin:$PATH
RUN jupyter contrib nbextension install --user

# cleanup tarballs and downloaded package files
RUN conda clean -tp -y

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Work directory
RUN ["mkdir", "-p", "/src/outputs"]
VOLUME ["/src"]
WORKDIR "/src"

# Keras directory
RUN ["mkdir", "/root/.keras"]
VOLUME ["/root/.keras"]

# Make sure CUDNN is detected
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64/:$LD_LIBRARY_PATH
RUN ln -s /usr/local/cuda/lib64/libcudnn.so.5 /usr/local/cuda/lib64/libcudnn.so

# TensorBoard
EXPOSE 6006
# Jupyter
EXPOSE 8888
# Flask Server
EXPOSE 4567

COPY run-jupyter.sh /
RUN chmod +x /run-jupyter.sh
ENTRYPOINT ["/run-jupyter.sh"]

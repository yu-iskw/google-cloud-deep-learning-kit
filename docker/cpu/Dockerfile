FROM ubuntu:16.04

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
COPY environment-cpu.yml  ./environment.yml
RUN conda env create -f environment.yml -n jupyter-keras-cpu
ENV PATH /miniconda/envs/jupyter-keras-cpu/bin:$PATH

# Install jupyter extensions
RUN pip install -U jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
  && jupyter contrib nbextension install --system \
  && jupyter nbextensions_configurator enable --system
RUN mkdir -p $(jupyter --data-dir)/nbextensions \
  && cd $(jupyter --data-dir)/nbextensions \
  && git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding \
  && jupyter nbextension enable vim_binding/vim_binding

# download NLTK data
#RUN pip install -U nltk && python -m nltk.downloader -d /usr/local/share/nltk_data all

# cleanup tarballs and downloaded package files
RUN conda clean --all -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up our notebook config.
COPY jupyter_notebook_config.py /root/.jupyter/

# Work directory
RUN ["mkdir", "-p", "/src/outputs"]
VOLUME ["/src"]
WORKDIR "/src"

# Keras directory
RUN ["mkdir", "/root/.keras"]
VOLUME ["/root/.keras"]

# TensorBoard
EXPOSE 6006
# Jupyter
EXPOSE 8888
# Flask Server
EXPOSE 4567

COPY run-jupyter.sh /
RUN chmod +x /run-jupyter.sh
CMD ["/run-jupyter.sh"]

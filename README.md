# Google Cloud Deep Learning Kit

This repository aims to create a GPU instance with Jupyter, Tensorflow and Keras on google cloud platform in an instant.

![Overview](./docs/overview.png)

## Requirements

- make
- Google Cloud SDK
- Docker

## Life Cycle to Use this Kit

1. Create an instance with `make create-instance` or `make create-instance-cpu`
2. Run jupyter on the instance with `make run-jupyter`
  - It may takes 5 minutes or so.
3. Install python libraries with `make pip-install`
  - Put libraries you want to install in `./requirements.txt`
4. Upload files to the instance with `make upload-files`.
5. Make ssh tunnel to the instance with `make ssh-tunnel`
6. Access jupyter via your web browser
  - Default: `http://localhost:18888`
7. Download outputs with `make download-outputs`
8. Delete the instance with `make delete-instance`

## Installed python libraries in the docker image

The pre-built docker image on Docker Hub is created with the following anaconda environment YAML.
Don't worry, you can additionally install other python library with `make pip-install`, if you want.

[Anaconda Environment YAML](./docker/environment-gpu.yml)

## Commands Reference

### Create a GCP instance with GPUs
It may take 5 minutes or so to finish to execute the startup script to install the require environment in your instance.
We have two CUDA version, 8.0 and 9.0.
Please make sure which version you want to use.
If you create an instance with CUDA 8, you can run only docker images to be customized to CUDA 8.
Likewize, if you create an instance with CUDA 9, you can run only docker images to be customized to CUDA 8.
As you know, tensorflow 1.4- does not support CUDA 9.
Please pay attention to CUDA version and tensorflow version before you make an GCP instance.

```
make create-instance \
  CUDA_VERSION=8 \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx
```

The command has some options as following:
- `CUDA_VERSION`: CUDA version. Default: `8`. Either of `8` or `9`.
- `INSTANCE_NAME`: GCP instance name
- `GCP_PROJECT_ID`: GCP project ID
- `MACHINE_TYPE`: GCP instance machine type
- `ACCELERATOR`: Attached accelerator
- `BOOT_DISK_SIZE`: boot disk size
- `GCP_INSTANCE_SCOPES`: scopes

Please change `ACCELERATOR` to what you want, when you would like to modify the accelerator of a GCP instance
The default value of `ACCELERATOR` is `type=nvidia-tesla-k80,count=1`.

### Create a GCP instance without GPUs
When you would like to make a GCP instance without GPU, I would recommend you to execute `make create-instance-cpu`.

```
make create-instance-cpu \
  INSTANCE_NAME="test-cpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  GCP_ZONE=us-central1-f \
  MACHINE_TYPE=n1-standard-32
```
The command has some options as following:
- `INSTANCE_NAME`: GCP instance name
- `GCP_PROJECT_ID`: GCP project ID
- `MACHINE_TYPE`: GCP instance machine type
- `BOOT_DISK_SIZE`: boot disk size
- `GCP_INSTANCE_SCOPES`: scopes

### Run Jupyter as a docker container

#### Run Jupyter as a docker container on a GPU instance
We can run jupyter on the docker container with the command.
When a container for jupyter is running, it will restart the container.
```
make run-jupyter \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  DOCKER_IMAGE_GPU=tf-1.6-gpu-cuda8
```

We support some types of docker image for GPU.
As we described above, please make sure the CUDA version of an instance you made.
- `tf-1.4-gpu`: Tensorflow 1.4 for GPU
- `tf-1.5-gpu-cuda8`: Tensorflow 1.5 with CUDA8 for GPU
- `tf-1.5-gpu-cuda9`: Tensorflow 1.5 WITH CUDA9 for GPU
- `tf-1.6-gpu-cuda8`: Tensorflow 1.6 with CUDA8 for GPU
- `tf-1.6-gpu-cuda9`: Tensorflow 1.6 WITH CUDA9 for GPU

#### Run Jupyter as a docker container on a CPU instance
When you launch a GCP instance with `make create-instance-cpu`, you must use the command in order to run a container for jupyter.
Because the docker image with GPUs is totally different from that without GPUs.
```
make run-jupyter-cpu \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  DOCKER_IMAGE_CPU=tf-1.6-cpu
```

We support some types of docker image for GPU.
- `tf-1.4-cpu`: Tensorflow 1.4 for CPU
- `tf-1.5-cpu`: Tensorflow 1.4 for CPU
- `tf-1.6-cpu`: Tensorflow 1.4 for CPU

### SSH tunnel
In order to access the jupyter which you launched, you have to have a SSH tunnel.
When you got it, you can access `http://localhost:18888` via a web browser on your local machine.
When you don't set any value with `make ssh-tunnel`, the port is the default value.
The default of `JUPYTER_PORT` is `18888`.

```
make ssh-tunnel \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  JUPYTER_PORT=18888
```

### Delete the instance you created

The command is used for deleting the GCP instance you created.
Please don't forget to do that after you finish your works!

```
make delete-instance \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx
```

### Install python libraries

If you want to install python libraries other than pre-installed ones, please add them to `./requirements.txt` and then execute the below command:
When you restart a container to run jupyter, we must re-execute the commahd.

```
make pip-install \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx
```

### Upload your files
This command allows us to upload files on a local machine to the instance.
Those files will be set at `/src` on the GCP machine and the docker container will mount it at `/src`.

```
make upload-files \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  FROM=/path/to/your/files
```

### Download ouputs
This command allows us to download files under `/src/outputs` in the instance.
When you save trained models and some predicted results under `/src/outputs`, you can download them with it.

```
make download-outputs \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  TO=/path/to/your/destination
```

## Jupyter extensions
Jupyter in this docker image has extensions as default.
If you would like to turn off some extensions, please visit `http://localhost:18888/nbextensions`.

## Links
- [yuiskw/google\-cloud\-deep\-learning\-kit \- Docker Hub](https://hub.docker.com/r/yuiskw/google-cloud-deep-learning-kit/)

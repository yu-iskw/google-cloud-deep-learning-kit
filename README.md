# Google Cloud Deep Learning Kit

This repository aims to create a GPU instance with Jupyter, Tensorflow and Keras on google cloud platform in an instant.

![Overview](./docs/overview.png)

## Requirements

- make
- Google Cloud SDK
- Docker

## Life Cycle to Use this Kit

1. Create an instance with `make create-instance`
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

## Commands Reference

### Create a GCP instance with GPU

It may take 5 minutes or so to finish to execute the startup script to install the require environment in your instance.

```
make create-instance \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx
```

### Run Jupyter as a docker container

```
make run-jupyter \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx
```

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

### Delete a instance you created

```
make delete-instance \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx
```

### Install python libraries

```
make pip-install \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx
```

### Upload your files

```
make upload-files \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  FROM=/path/to/your/files
```

### Download ouputs

```
make download-outputs \
  INSTANCE_NAME="test-gpu-instance" \
  GCP_PROJECT_ID=xxx-xxx-xxx \
  TO=/path/to/your/destination
```

## Links
- [yuiskw/google\-cloud\-deep\-learning\-kit \- Docker Hub](https://hub.docker.com/r/yuiskw/google-cloud-deep-learning-kit/)

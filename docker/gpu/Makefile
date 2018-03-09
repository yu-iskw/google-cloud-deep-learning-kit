DOCKER_TAG := yuiskw/google-cloud-deep-learning-kit
LATEST_VERSION := latest-gpu
VERSION_CUDA8 := tf-1.6-gpu-cuda8
VERSION_CUDA9 := tf-1.6-gpu-cuda9
VERION_DOCKER_TAG := $(DOCKER_TAG):$(VERSION)

build-docker: build-docker-cuda8 build-docker-cuda9

build-docker-cuda8:
	docker build -f ./Dockerfile.cuda8 -t $(DOCKER_TAG):$(VERSION_CUDA8) .

build-docker-cuda9:
	docker build -f ./Dockerfile.cuda9 -t $(DOCKER_TAG):$(VERSION_CUDA9) .

push-docker: push-docker-cuda8 push-docker-cuda9

push-docker-cuda8:
	docker push $(DOCKER_TAG):$(VERSION_CUDA8)

push-docker-cuda9:
	docker push $(DOCKER_TAG):$(VERSION_CUDA9)

test-run-jupyter:
	docker run -it --rm -d -p 8888:28888 --name jupyter $(VERION_DOCKER_TAG)

create-conda:
	conda env create -f ./environment-gpu.yml -n jupyter-keras-gpu

remove-conda:
	conda env remove -n jupyter-keras-gpu

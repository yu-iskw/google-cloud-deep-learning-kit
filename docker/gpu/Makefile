DOCKER_TAG := yuiskw/google-cloud-deep-learning-kit
LATEST_VERSION := latest-gpu
VERSION := tf-1.4-gpu
LATEST_DOCKER_TAG := $(DOCKER_TAG):$(LATEST_VERSION)
VERION_DOCKER_TAG := $(DOCKER_TAG):$(VERSION)

build-docker:
	docker build . -t $(LATEST_DOCKER_TAG) \
		&& docker build . -t $(VERION_DOCKER_TAG)

push-docker:
	docker push $(VERION_DOCKER_TAG)

push-docker-latest:
	docker push $(LATEST_DOCKER_TAG)

test-run-jupyter:
	docker run -it --rm -d -p 8888:28888 --name jupyter $(VERION_DOCKER_TAG)

create-conda:
	conda env create -f ./environment-gpu.yml -n jupyter-keras-gpu

remove-conda:
	conda env remove -n jupyter-keras-gpu

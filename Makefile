#INSTANCE_NAME := XXXX
#GCP_PROJECT_ID := XXXX
GCP_ZONE := us-west1-b
MACHINE_TYPE := n1-standard-8
ACCELERATOR := type=nvidia-tesla-k80,count=1
BOOT_DISK_SIZE := 200GB

DOCKER_IMAGE_GPU := tf-1.5-gpu
DOCKER_IMAGE_CPU := tf-1.5-cpu

JUPYTER_PORT := 18888

GCP_INSTANCE_SCOPES := default,bigquery,cloud-platform,storage-rw

create-instance: check-instance-name check-gcp-project-id check-gcp-zone
	./bin/create-instance.sh \
		$(INSTANCE_NAME) \
		$(GCP_PROJECT_ID) \
		$(GCP_ZONE) \
		$(MACHINE_TYPE) \
		$(ACCELERATOR) \
		$(BOOT_DISK_SIZE) \
		$(GCP_INSTANCE_SCOPES)

create-instance-cpu: check-instance-name check-gcp-project-id check-gcp-zone
	./bin/create-instance-cpu.sh \
		$(INSTANCE_NAME) \
		$(GCP_PROJECT_ID) \
		$(GCP_ZONE) \
		$(MACHINE_TYPE) \
		$(BOOT_DISK_SIZE) \
		$(GCP_INSTANCE_SCOPES)

delete-instance: check-instance-name check-gcp-project-id check-gcp-zone
	gcloud compute instances delete $(INSTANCE_NAME) --project $(GCP_PROJECT_ID) --zone $(GCP_ZONE)

run-jupyter: check-instance-name check-gcp-project-id check-gcp-zone
	$(eval COMMAND := sudo nvidia-docker kill jupyter \
		|| true \
		&& sudo nvidia-docker run -it --rm -d -v /src:/src -p 8888:8888 \
		--name jupyter yuiskw/google-cloud-deep-learning-kit:$(DOCKER_IMAGE_GPU))
	./bin/execute-over-ssh.sh $(INSTANCE_NAME) $(GCP_PROJECT_ID) $(GCP_ZONE) "$(COMMAND)"

run-jupyter-cpu: check-instance-name check-gcp-project-id check-gcp-zone
	$(eval COMMAND := sudo docker kill jupyter \
		|| true \
		&& sudo docker run -it --rm -d -v /src:/src -p 8888:8888 \
		--name jupyter yuiskw/google-cloud-deep-learning-kit:$(DOCKER_IMAGE_CPU))
	./bin/execute-over-ssh.sh $(INSTANCE_NAME) $(GCP_PROJECT_ID) $(GCP_ZONE) "$(COMMAND)"

upload-files: check-instance-name check-gcp-project-id check-gcp-zone check-from
	gcloud compute scp $(FROM) $(INSTANCE_NAME):/src \
		--project $(GCP_PROJECT_ID) \
		--zone $(GCP_ZONE) \
		--compress \
		--recurse

download-outputs: check-instance-name check-gcp-project-id check-gcp-zone check-to
	-mkdir -p "$(TO)"
	gcloud compute scp $(INSTANCE_NAME):/src/outputs/* $(TO) \
		--project $(GCP_PROJECT_ID) \
		--zone $(GCP_ZONE) \
		--recurse

pip-install: check-instance-name check-gcp-project-id check-gcp-zone
	# Copy requirements.txt to your instance
	gcloud compute scp ./requirements.txt $(INSTANCE_NAME):/src/requirements.txt \
		--project $(GCP_PROJECT_ID) \
		--zone $(GCP_ZONE)
	# Pip install to Docker
	$(eval COMMAND := sudo nvidia-docker exec jupyter pip install -r /src/requirements.txt)
	./bin/execute-over-ssh.sh $(INSTANCE_NAME) $(GCP_PROJECT_ID) $(GCP_ZONE) "$(COMMAND)"

ssh-tunnel: check-instance-name check-gcp-project-id check-gcp-zone check-jupyter-port
	gcloud compute ssh $(INSTANCE_NAME) \
		--project $(GCP_PROJECT_ID) \
		--zone $(GCP_ZONE) \
		--ssh-flag="-L" \
		--ssh-flag="$(JUPYTER_PORT):localhost:8888"

check-instance-name:
ifndef INSTANCE_NAME
	$(error INSTANCE_NAME is undefined)
endif

check-gcp-project-id:
ifndef GCP_PROJECT_ID
	$(error GCP_PROJECT_ID is undefined)
endif

check-gcp-zone:
ifndef GCP_ZONE
	$(error GCP_ZONE is undefined)
endif

check-jupyter-port:
ifndef JUPYTER_PORT
	$(error JUPYTER_PORT is undefined)
endif

check-from:
ifndef FROM
	$(error FROM is undefined)
endif

check-to:
ifndef TO
	$(error TO is undefined)
endif

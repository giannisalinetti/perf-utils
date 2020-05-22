APP_NAME=perf-utils
REGISTRY=quay.io
NAMESPACE=gbsalinetti

build:
	buildah bud -t $(APP_NAME) .

tag:
	podman tag $(APP_NAME) $(REGISTRY)/$(NAMESPACE)/$(APP_NAME):latest

push:
	podman push $(REGISTRY)/$(NAMESPACE)/$(APP_NAME):latest


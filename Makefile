IMAGE_NAME=ansible-image
PIP_VERSION=19.3.1
SETUPTOOLS_VERSION=41.6.0
REGISTRY=myregistry:5000/folder/

build:
	docker build \
                --build-arg proxy=$(HTTP_PROXY) \
		--build-arg PIP_VERSION=$(PIP_VERSION) \
		--build-arg SETUPTOOLS_VERSION=$(SETUPTOOLS_VERSION) \
		-t $(IMAGE_NAME) .

test:
	docker run --rm $(IMAGE_NAME) ansible --version
	docker run --rm $(IMAGE_NAME) pip --version | grep $(PIP_VERSION)

push:
	docker tag $(IMAGE_NAME) $(REGISTRY)$(IMAGE_NAME)
	docker push $(REGISTRY)$(IMAGE_NAME)

# exported variables will be available in bats files too
export TAG := 8.2
export TEST_TAG := $(TAG)-test-kitchenpan
export IMG_NAME := abtpeople/pentaho-di

BUILD_DIR := build
VPATH := docker:$(BUILD_DIR)

all: image

.PHONY: all images-test test test-* clean clean-*

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

image: Dockerfile docker-entrypoint.sh carte_config_master.xml carte_config_slave.xml $(BUILD_DIR)
	docker build -t $(IMG_NAME):$(TAG) docker
	touch $(BUILD_DIR)/$@

images-test: image-test-kitchenpan

image-test-kitchenpan: test/docker-kitchenpan/Dockerfile test/docker-kitchenpan/.kettle/* \
		test/docker-kitchenpan/repo/* $(BUILD_DIR)
	docker build -t $(IMG_NAME):$(TEST_TAG) test/docker-kitchenpan
	touch $(BUILD_DIR)/$@

test: image image-test-kitchenpan
	bats test

clean: clean-image clean-images-test
	-rmdir $(BUILD_DIR)

clean-image:
	-docker rmi $(IMG_NAME):$(TAG)
	-rm $(BUILD_DIR)/image

clean-images-test: clean-image-test-kitchenpan

clean-image-test-kitchenpan:
	-docker rmi $(IMG_NAME):$(TEST_TAG)
	-rm $(BUILD_DIR)/image-test-kitchenpan

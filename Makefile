#SHELL := /usr/bin/env bash

# exported variables will be available in bats files too
export TAG := 8.2
export TEST_TAG := $(TAG)-test-kitchenpan
export IMG_NAME := abtpeople/pentaho-di
export UTEST_TAG := $(TAG)-unittest

BUILD_DIR := build
UNIT_TEST_DIR := unit-test/docker/home/
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

image-unittest: unit-test/docker/Dockerfile unit-test/docker/home/.kettle/* \
		unit-test/docker/home/* $(BUILD_DIR)
	docker build -t $(IMG_NAME):$(UTEST_TAG) unit-test/docker
	touch $(BUILD_DIR)/$@

test: image image-test-kitchenpan copy-kettle-home
	bats test

unit-test: image copy-kettle-home image-unittest
	unit-test/unit-test.sh "$(IMG_NAME):$(UTEST_TAG)"

copy-kettle-home: clean-kettle-home
ifeq ($(KETTLE_HOME),)
$(error KETTLE_HOME is222 not set)
endif
	cp -R $(KETTLE_HOME)/* $(UNIT_TEST_DIR)
	mkdir $(UNIT_TEST_DIR).kettle
	grep -v PENTAHO_METASTORE_FOLDER $(KETTLE_HOME)/.kettle/kettle.properties > $(UNIT_TEST_DIR).kettle/kettle.properties
	echo 'PENTAHO_METASTORE_FOLDER=/pentaho-di' >> $(UNIT_TEST_DIR).kettle/kettle.properties
	sed -i -e "s@$(KETTLE_HOME)@/pentaho-di@" $(UNIT_TEST_DIR)metastore/pentaho/Kettle\ Transformation\ Unit\ Test/*.xml

clean-kettle-home:
	-rm -rf $(UNIT_TEST_DIR)*
	-rm -rf $(UNIT_TEST_DIR).kettle

clean: clean-image clean-images-test
	-rmdir $(BUILD_DIR)
	-rm -rf $(UNIT_TEST_DIR)*
	-rm -rf $(UNIT_TEST_DIR).kettle

clean-image:
	-docker rmi $(IMG_NAME):$(TAG)
	-rm $(BUILD_DIR)/image
	-rm $(BUILD_DIR)/image-unittest

clean-images-test: clean-image-test-kitchenpan

clean-image-test-kitchenpan:
	-docker rmi $(IMG_NAME):$(TEST_TAG)
	-rm $(BUILD_DIR)/image-test-kitchenpan

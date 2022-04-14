IMAGE = smm/hadoop.base
HADOOP_VERSION = 3.3.1

DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
.PHONY: all build clean test

all: build

build:
	
	docker build -t $(IMAGE):$(HADOOP_VERSION) .
clean:
	@[ -z $(docker images -q $(IMAGE):$(HADOOP_VERSION)) ] || docker rmi $(IMAGE):$(HADOOP_VERSION)


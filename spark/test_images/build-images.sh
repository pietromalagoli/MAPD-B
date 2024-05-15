#!/bin/bash
docker build \
 -f base-image.Dockerfile \
 -t base-image \
 --platform=linux/amd64 .

docker build \
 -f spark-master.Dockerfile \
 -t spark-master \
 --platform=linux/amd64 .

docker build \
 -f spark-worker.Dockerfile \
 -t spark-worker \
 --platform=linux/amd64 .

docker build \
 -f spark-jupyter.Dockerfile \
 -t spark-jupyter \
 --platform=linux/amd64 .

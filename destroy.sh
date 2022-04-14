#!/bin/bash

docker stop hadoop-master hadoop-slave2 hadoop-slave3
docker rm hadoop-master hadoop-slave2 hadoop-slave3
docker rmi smm/hadoop-master:3.3.1 smm/hadoop-slave:3.3.1
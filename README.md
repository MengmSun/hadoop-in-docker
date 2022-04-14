# hadoop-in-docker


Total distributed hadoop in docker cluster built in **less than 5 minutes**,  created by docker-compose. Now it can support HDFS file system, and I will add Hbase ,Zookeeper and other hadoop family members to the docker cluster.

*If you have any suggestion or question, feel free to contact me, and welcome to [issues](https://github.com/MengmSun/hadoop-in-docker/issues).* :smiley:


<video id="video" controls="" src="./test.mp4" preload="true"></video>

- [hadoop-in-docker](#hadoop-in-docker)
    - [Build Base Image](#build-base-image)
    - [Create Share Volume Mount Path](#create-share-volume-mount-path)
    - [Build&Start hadoop docker cluster](#buildstart-hadoop-docker-cluster)
    - [Destroy the cluster and images](#destroy-the-cluster-and-images)
    - [Other test commands](#other-test-commands)
    - [Extension & Wait to be updated](#extension--wait-to-be-updated)
    - [Common Questions & Solutions](#common-questions--solutions)


**Environments:**
- docker
- docker-compose


**Packages:**
- hadoop-3.3.1
  
  You can install tar.gz from [hadoop list](https://archive.apache.org/dist/hadoop/common/hadoop-3.3.1/) and choose other version. But if you have no interest in change the source file or DIY ,you'd better install the version of 3.3.1. I'll fix up the repo to support many versions with little configuration later.

*Other packages updating...*

### Build Base Image
 - Put your hadoop package under the /base path, then build the base image locally.
  
     ```bash
     cd ./base
     make all
     ```
  After a few minutes, the base image(smm/hadoop.base:3.3.1) will be build successfully.

### Create Share Volume Mount Path
 - I have mounted two path to share ssh_key and hadoop etc files among the docker cluster simply. These files **must** be the same among different docker containers.

    ```bash
    # under /hadoop-in-docker/
    mkdir .secret
    mkdir share
    ```

### Build&Start hadoop docker cluster
- docker-compose
  ```bash
  docker-compose up -f s2-docker-compose.yml
  # docker-compose up -f s2-docker-compose.yml -d
  ```
  if you want to run it in the background, you can add `-d` param.

  If everything is OK, you can see `Hdfs done...` at end. If without `-d`, the process may  wait for a little long time at `permission set`(About half minute or longer). With `-d` , it will cost just few seconds. 

### Destroy the cluster and images
- run the destroy shell
  ```bash
  chmod +x ./destroy.sh
  ./destroy.sh
  ```
  
### Other test commands
- If you want to enter single node, you can :
  ```bash
  docker exec -it hadoop-master su # enter the container as root
  su hdfs # change user to hdfs
  jps # look at hdfs java process
  # Use other hdfs commands to test
    hdfs dfs -mkdir /user
    hdfs dfs -mkdir /user/catcher/
    hdfs dfs -mkdir /input
    hdfs dfs -put $HADOOP_HOME/etc/hadoop/*.xml /input
    hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.1.jar grep /input /output 'dfs[a-z.]+'
    hdfs dfs -get /output ./output
    cat ./output/*
  ```
  
### Extension & Wait to be updated
- Change slave nodes nums:
  
  In theory, you can DIY as many slaves&masters you want. 
  - Create another docker-compose.yml file.
  - change the `/hadoop-master/docker-entrypoint.sh` and the `/hadoop-slave/docker-entrypoint.sh` ,find `dfs.replication` change the value to node nums you want.
  - change the `_set_workers()`  function in the 2 files above, write in  all the  hostnames.

- Add other hadoop family members:
  
  Waiting to be done...

### Common Questions & Solutions
1. Build base image error ,cause by centos8.repo source
   
   Due to centos org stop to support centos8 , I use aliyun mirror instead. You can find other solutions.
   If still have other strange error, you can change the image source form centos8 to other linux system image. Just change the `yum` to others(like apt for Ubuntu).

2. Hadoop problems caused by JAVA_HOME 
   
   At `docker-entrpoint.sh` `set_java_hadoop_path()` function:
   ```bash
   export JAVA_HOME=\/usr\/lib\/jvm\/java-1.8.0-openjdk-1.8.0.312.b07-2.el8_5.x86_64
   ```
   Here, the path depends on your system and downloaded java version. If you don't know the correct path, you can create a **test** container form `smm/hadoop.base:3.3.1` , enter the container and find the path.





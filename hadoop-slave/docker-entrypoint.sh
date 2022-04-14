#!/bin/bash
set -e

# set JAVA & HADOOP env variables for all users
_set_java_hadoop_env() {
    cd /etc
    sed -i '$aexport HADOOP_HOME=\/usr\/local\/hadoop-3.3.1\n\
    \export JAVA_HOME=\/usr\/lib\/jvm\/java-1.8.0-openjdk-1.8.0.312.b07-2.el8_5.x86_64\n\
    \export CLASSPATH=.:$JAVA_HOME\/jre\/lib:$JAVA_HOME\/lib:$JAVA_HOME\/lib\/tools.jar\n\
    \export PATH=$PATH:$HADOOP_HOME\/bin:$HADOOP_HOME\/sbin:$JAVA_HOME\/bin\n' profile
    source /etc/profile
    sed -i '$asource \/etc\/profile\n' ~/.bashrc
    source ~/.bashrc
    sed -i '$asource \/etc\/profile\n' /home/hdfs/.bashrc
    source /home/hdfs/.bashrc
    echo "PATH done..."
}

# set HDFS env variables for all users
_set_hdfs_env() {
    cd /usr/local/hadoop-3.3.1
    # change HDFS_JAVA_HOME
    sed -i '$aHDFS_JAVA_HOME=/usr' ./etc/hadoop/hadoop-env.sh
    echo "HDFS_JAVA_HOME done..."
}

# start sshd server
# copy authorized_keys to /.secret directory for other nodes
_sshd_host() {
    #ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
    #cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
    #chmod 0600 ~/.ssh/authorized_keys
    /usr/sbin/sshd
    echo ">>>>>>>>>>>>>>>>>>>>"
    mkdir -p /home/hdfs/.ssh
    ssh-keygen -t rsa -P '' -f /home/hdfs/.ssh/id_rsa
    cp /.secret/authorized_keys /home/hdfs/.ssh/authorized_keys
    #cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
    chown -R hdfs /home/hdfs/.ssh
    chmod 0600 /home/hdfs/.ssh/authorized_keys
    #ls -l /run/nologin
    #rm -rf /run/nologin
    echo "Slave SSH done..."
}

# change core-site.xml
_set_core_site_xml() {
    cd /usr/local/hadoop-3.3.1
    mkdir -p data
    mkdir -p ./data/temp
    cd ./etc/hadoop
    sed -i '/^<configuration>/a <property>\n\
    \<name>hadoop.tmp.dir</name>\n\
    \<value>/usr/local/hadoop-3.3.1/data/temp</value>\n\
    \</property>\n' core-site.xml
    sed -i '/^<configuration>/a <property>\n\
    \<name>fs.defaultFS</name>\n\
    \<value>hdfs://hadoop-master:8020</value>\n\
    \</property>\n' core-site.xml
    echo "core-site.xml done..."
}

# change hdfs-site.xml
_set_hdfs_site_xml() {
    cd /usr/local/hadoop-3.3.1
    mkdir -p ./data/datanode
    mkdir -p ./data/namenode
    mkdir -p dfs
    mkdir -p ./dfs/namenode
    mkdir -p ./dfs/namenode/edits
    cd ./etc/hadoop
    sed -i '/^<configuration>/a <property>\n\
    \<name>dfs.replication</name>\n\
    \<value>3</value>\n\
    \</property>\n' hdfs-site.xml
    sed -i '/^<configuration>/a <property>\n\
    \<name>dfs.namenode.http-address</name>\n\
    \<value>hadoop-master:9870</value>\n\
    \</property>\n' hdfs-site.xml
    sed -i '/^<configuration>/a <property>\n\
    \<name>dfs.namenode.secondary.http-address</name>\n\
    \<value>hadoop-master:9868</value>\n\
    \</property>\n' hdfs-site.xml
    sed -i '/^<configuration>/a <property>\n\
    \<name>dfs.datanode.data.dir</name>\n\
    \<value>file:///usr/local/hadoop-3.3.1/data/datanode</value>\n\
    \</property>\n' hdfs-site.xml
    sed -i '/^<configuration>/a <property>\n\
    \<name>dfs.namenode.name.dir</name>\n\
    \<value>file:///usr/local/hadoop-3.3.1/data/namenode</value>\n\
    \</property>\n' hdfs-site.xml
    sed -i '/^<configuration>/a <property>\n\
    \<name>dfs.namenode.edits.dir</name>\n\
    \<value>file:///usr/local/hadoop-3.3.1/dfs/namenode/edits</value>\n\
    \</property>\n' hdfs-site.xml
    sed -i '/^<configuration>/a <property>\n\
    \<name>dfs.permission.enabled</name>\n\
    \<value>false</value>\n\
    \</property>\n' hdfs-site.xml
    echo "hdfs-site.xml done..."

}

# change workers
_set_workers() {
    cd /usr/local/hadoop-3.3.1/etc/hadoop
    cat > workers <<EOF
hadoop-master
hadoop-slave2
hadoop-slave3
EOF
    echo "workers done..."
}

# change log4j.properties
_set_log4j_properties() {
    cd /usr/local/hadoop-3.3.1/etc/hadoop
    sed -i '$alog4j.logger.org.apache.hadoop.util.NativeCodeLoader=ERROR\n' log4j.properties
    echo "log4j.properties done..."
}


# copy etc files to /share
#_copy_etc_files() {
#     cd /usr/local/hadoop-3.3.1/etc
#     cp -r hadoop /share/
#     echo "etc files done..."
#}

# change permission
_set_permission() {
    cd /usr/local
    chown -R hdfs hadoop-3.3.1/data
    chown -R hdfs hadoop-3.3.1/dfs
    chmod -R g+rwx hadoop-3.3.1
    echo "Slave permission done..."
}

# main

_set_java_hadoop_env
_set_hdfs_env
_sshd_host
_set_core_site_xml
_set_hdfs_site_xml
_set_workers
_set_log4j_properties
_set_permission

tail -f /dev/null

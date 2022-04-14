FROM roboxes/centos8:latest



RUN groupadd hadoop

RUN useradd -m -g hadoop hadoop \
  && useradd -m -g hadoop hdfs \
  && useradd -m -g hadoop mapred \
  && useradd -m -g hadoop yarn \
  && useradd -m -g hadoop hbase

# copy hadoop3.3.1.tar.gz to /usr/local/

COPY hadoop-3.3.1-aarch64.tar.gz /usr/local/
WORKDIR /usr/local
RUN tar -xzf hadoop-3.3.1-aarch64.tar.gz \
  && chown -R hadoop:hadoop hadoop-3.3.1 \
  && chmod -R g+rwx hadoop-3.3.1

# change the repo source to aliyun
# due to centos org stop to support centos8 , you can find other solutions
RUN rename '.repo' '.repo.bak' /etc/yum.repos.d/*.repo \
  && wget https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo -O /etc/yum.repos.d/Centos-vault-8.5.2111.repo \
#  && wget https://mirrors.aliyun.com/repo/epel-archive-8.repo -O /etc/yum.repos.d/epel-archive-8.repo \
  && sed -i 's/mirrors.cloud.aliyuncs.com/url_tmp/g'  /etc/yum.repos.d/Centos-vault-8.5.2111.repo \
  && sed -i 's/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/Centos-vault-8.5.2111.repo \
  && sed -i 's/url_tmp/mirrors.aliyun.com/g' /etc/yum.repos.d/Centos-vault-8.5.2111.repo \
#  && sed -i 's/mirrors.aliyun.com/mirrors.cloud.aliyuncs.com/g' /etc/yum.repos.d/epel-archive-8.repo  \
  && yum clean all \
  && yum makecache \
  && yum -y install java-1.8.0-openjdk \
  java-1.8.0-openjdk-devel \
  which \
  sudo \
  wget \
  tree \
  openssh-server \
  openssh-clients \
  initscripts 
#COPY ./init.sh /root/


# hdfs
# yarn
# hbase
# hive
# zookeeper
# ssh



VOLUME [ "/share", "/.secret" ]
EXPOSE 50010 50075 50475 50020 50070 50470 8020 8485 \
  8480 8030 8031 8032 8033 8088 8040 8042 8041 10020 19888 \
  60000 60010 60020 60030 2181 2888 3888 \
  9083 10000 \
  2181 2888 3888 \
  22

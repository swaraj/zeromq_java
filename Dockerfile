# DOCKER-VERSION 1.0.1
# VERSION        1.0

FROM debian:jessie
MAINTAINER Swaraj Yadav <yadav.swaraj@gmail.com>

# Install openjdk and other required utilities
RUN apt-get update
RUN apt-get install -y openjdk-7-jdk git wget vim net-tools
RUN echo "export JAVA_7_HOME=/usr/lib/jvm/java-7-openjdk-amd64" > /etc/profile.d/java.sh
RUN echo 'export JAVA_HOME=$JAVA_7_HOME' >> /etc/profile.d/java.sh
# RUN source /etc/profile

# Install zeromq 4.1.4
RUN apt-get install -y libtool libtool-bin pkg-config build-essential autoconf automake uuid-dev libsodium13 libsodium-dev
# Uncomment to install e2fsprogs if not already installed
# RUN apt-get install e2fsprogs
RUN wget -q -O - http://download.zeromq.org/zeromq-4.1.4.tar.gz | tar -xzf - -C /opt && mv /opt/zeromq-4.1.4 /opt/zeromq
RUN cd /opt/zeromq && ./configure && make && make install
RUN ldconfig


# Install java binding
RUN cd /root && git clone https://github.com/zeromq/jzmq.git && cd jzmq && ./autogen.sh && ./configure && make && make install
RUN ldconfig

COPY HwClient.java /root	
COPY HwServer.java /root

EXPOSE 5555

WORKDIR /root

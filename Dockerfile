FROM centos:7
MAINTAINER Jacek Kowalski <jkowalsk@student.agh.edu.pl>

# Gradle version to install
ENV GRADLE_INSTALL_VERSION 2.3

# Update system & install dependencies
RUN yum -y update \
	&& yum -y install cvs subversion git mercurial java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel ant maven unzip wget xorg-x11-server-Xvfb \
	&& yum -y clean all

# Install gradle
RUN cd /tmp \
	&& wget "https://services.gradle.org/distributions/gradle-${GRADLE_INSTALL_VERSION}-bin.zip" \
	&& unzip gradle-${GRADLE_INSTALL_VERSION}-bin.zip -d /opt \
	&& rm gradle-${GRADLE_INSTALL_VERSION}-bin.zip

# Install Oracle JDK
RUN wget --no-check-certificate --no-cookies \
	--header "Cookie: oraclelicense=accept-securebackup-cookie" \
	http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.rpm
RUN yum -y localinstall jdk-8u45-linux-x64.rpm
RUN rm -f jdk-8u45-linux-x64.rpm

RUN groupadd -r bamboo-agent && useradd -r -m -g bamboo-agent bamboo-agent

COPY bamboo-agent.sh /

USER bamboo-agent
CMD ["/bamboo-agent.sh"]

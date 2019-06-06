FROM jenkins/jnlp-slave

RUN rm -rf /home/jenkins/.ssh
RUN mkdir .ssh

COPY id_rsa.pub /home/jenkins/.ssh/id_rsa.pub.bk
COPY id_rsa /home/jenkins/.ssh/id_rsa.bk

RUN cp -p /home/jenkins/.ssh/id_rsa.bk /home/jenkins/.ssh/id_rsa
RUN cp -p /home/jenkins/.ssh/id_rsa.pub.bk /home/jenkins/.ssh/id_rsa.pub

RUN chmod 600 /home/jenkins/.ssh/id_rsa
RUN chmod 600 /home/jenkins/.ssh/id_rsa.pub

USER root

RUN apt-get remove openjdk* -y
RUN apt-get remove --auto-remove openjdk* -y
RUN apt-get purge openjdk* -y
RUN apt-get purge --auto-remove openjdk* -y

RUN apt-get -y install wget

RUN mkdir /usr/java/

WORKDIR /usr/java/
RUN wget http://URL/third-party/jdk/jdk-8u211-linux-x64.tar.gz
RUN tar zxvf jdk-8u211-linux-x64.tar.gz
RUN rm jdk-8u211-linux-x64.tar.gz

WORKDIR /home/jenkins

RUN groupadd docker
RUN usermod -aG docker jenkins

COPY permission.sh /home/jenkins/permission.sh

RUN chmod a+x /home/jenkins/permission.sh
RUN chmod 777 /home/jenkins/permission.sh

RUN echo sh /home/jenkins/permission.sh >> ~/.profile

USER jenkins

RUN rm /home/jenkins/.ssh/id_rsa.bk
RUN rm /home/jenkins/.ssh/id_rsa.pub.bk
ENV JAVA_HOME=/usr/java/jdk1.8.0_211/
ENV PATH=$PATH:$JAVA_HOME/bin

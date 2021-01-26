FROM centos:8
MAINTAINER Serhii Klymoshenko ""
ARG JENKHOME=/usr/lib/jenkins
ARG TMPDATA=$JENKHOME/tmpData
ARG HMDIR=./root/.jenkins

# INSTALL WGET, JENKINS, JAVA
RUN yum update -y && yum install wget git python3 vim -y && \
yum install java-1.8.0-openjdk-devel -y && java -version && \
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo && \
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key && \
yum update -y && mkdir -p ${JENKHOME}/tmpData && \
echo "Import complete SUCSESSFULL" && \
echo "Start to Install JEKINS" && \
yum install jenkins -y && \
echo "JEKINS has been Installed!!!"

#RUN alias ll='ls -al'
#docker-systemctl-replacement
#RUN cd /tmp/ && git clone https://github.com/gdraheim/docker-systemctl-replacement.git
# && cd /tmp/docker-systemctl-replacement && python3 testsuite.py
# wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo && \
# rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key && \

#Instal Jenkins CLI
RUN curl -L https://github.com/jenkins-zh/jenkins-cli/releases/latest/download/jcli-linux-amd64.tar.gz|tar xzv && mv jcli /usr/local/bin/

#INSTALL PLUGIN TO JENKINS
COPY ./plugins.txt $TMPDATA/plugins.txt
COPY jenkins-cli.jar ${JENKHOME}
#COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy
#COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

#CMD systemctl restart jenkins; read item
#RUN sleep 45 && pass="$(cat $HMDIR/secrets/initialAdminPassword)" && \
# echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "admin")' | java -jar ${JENKHOME}/jenkins-cli.jar -auth admin:$pass -s http://localhost:80/ groovy =
#systemctl restart jenkins && sleep 30 &&
#echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("admin", "admin")' | java -jar /usr/lib/jenkins/jenkins-cli.jar -auth admin:15b2fbbfcfb44f7da8d5157adf624bea -s http://localhost:80/ groovy =


#RUN apt update -y && \
# wget https://updates.jenkins-ci.org/download/war/2.121.2/jenkins.war && \
# mkdir -p ~/.jenkins/plugins && \
# cd ~/.jenkins/plugins && \
# wget https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/job-dsl/1.33/job-dsl-1.33.jpi

EXPOSE 22
EXPOSE 80
EXPOSE 8080
EXPOSE 5000
WORKDIR ${JENKHOME}
ENTRYPOINT ["java", "-jar", "jenkins.war", "HTTP_PORT=80"]


#!/bin/bash

echo "Install Jenkins stable release"
sudo yum update -y 
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo chkconfig jenkins on

echo "Install git"
sudo yum install -y git

echo "Making initial jenkins directory"
sudo mkdir -p /var/lib/jenkins

echo "Mount NFS to Jenkins AMI"
EFS_HOSTNAME="${efs_hostname}"
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_HOSTNAME:/ /var/lib/jenkins/
sudo chmod go+rw /var/lib/jenkins
echo "Starting Jenkins"
sudo service jenkins start
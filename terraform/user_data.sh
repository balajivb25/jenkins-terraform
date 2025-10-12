#!/bin/bash
sleep 30
apt update -y
apt install -y openjdk-17-jdk apache2 git wget tar curl

# Set JAVA_HOME permanently
echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> /etc/profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile

# Install Maven
wget https://downloads.apache.org/maven/maven-3/3.8.9/binaries/apache-maven-3.8.9-bin.tar.gz -P /tmp
tar xzvf /tmp/apache-maven-3.8.9-bin.tar.gz -C /opt
mv /opt/apache-maven-3.8.9 /opt/maven
echo "export M2_HOME=/opt/maven" >> /etc/profile
echo "export PATH=\$M2_HOME/bin:\$PATH" >> /etc/profile

# Git config
git config --global user.name "balajivb25"
git config --global user.email "balajiv.b25@gmail.com"

# Start Apache server
systemctl enable apache2
systemctl start apache2

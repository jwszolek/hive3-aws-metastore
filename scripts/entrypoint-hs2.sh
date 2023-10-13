#!/bin/sh

export HADOOP_HOME=/opt/hadoop-3.1.2
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.271.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.1.2.jar
export JAVA_HOME=/usr/local/openjdk-8

sleep 60

echo "Starting Hive server2..."
/opt/apache-hive-3.1.3-bin/bin/hive --hiveconf hive.root.logger=DEBUG,console --service hiveserver2

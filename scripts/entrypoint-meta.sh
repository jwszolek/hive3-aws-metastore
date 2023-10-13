#!/bin/sh

export HADOOP_HOME=/opt/hadoop-3.1.2
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.271.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.1.2.jar
export JAVA_HOME=/usr/local/openjdk-8

# Make sure mariadb is ready
MAX_TRIES=8
CURRENT_TRY=1
SLEEP_BETWEEN_TRY=4

until [ "$(telnet db 3307 | sed -n 2p)" = "Connected to db." ] || [ "$CURRENT_TRY" -gt "$MAX_TRIES" ]; do
    echo "Waiting for mysql server..."
    sleep "$SLEEP_BETWEEN_TRY"
    CURRENT_TRY=$((CURRENT_TRY + 1))
done

if [ "$CURRENT_TRY" -gt "$MAX_TRIES" ]; then
  echo "WARNING: Timeout when waiting for mariadb."
fi

sleep 30

# Check if schema exists
/opt/apache-hive-3.1.3-bin/bin/schematool -dbType mysql -info

if [ $? -eq 1 ]; then
  echo "Getting schema info failed. Probably not initialized. Initializing..."
  /opt/apache-hive-3.1.3-bin/bin/schematool -initSchema -dbType mysql
fi

# /opt/apache-hive-metastore-3.0.0-bin/bin/start-metastore
echo "Starting Hive Metastore..."
/opt/apache-hive-3.1.3-bin/bin/hive --hiveconf hive.root.logger=DEBUG,console --service metastore

FROM openjdk:8u342-jre

RUN apt-get update \
 && apt-get install --assume-yes python3 python3-pip procps \
 && apt-get clean

RUN pip3 install pyspark~=3.3.1 pandas~=1.5.3

RUN apt-get update \
 && apt-get install --assume-yes telnet \
 && apt-get clean

WORKDIR /opt

ENV HADOOP_VERSION=3.1.2
ENV METASTORE_VERSION=3.0.0

COPY apache-hive-3.1.3-bin.tar.gz .
COPY hadoop-3.1.2.tar.gz .
COPY mysql-connector-java-8.0.19.tar.gz .

# docker run -p 10000:10000 -p 10002:10002 --env SERVICE_NAME=hiveserver2 \
# --env SERVICE_OPTS="-Dhive.metastore.uris=thrift://localhost:9083" \
# --env IS_RESUME="true" \
# apache/hive:3.1.3

RUN tar -zxf apache-hive-3.1.3-bin.tar.gz
RUN tar -zxf hadoop-3.1.2.tar.gz
RUN tar -zxf mysql-connector-java-8.0.19.tar.gz

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-3.1.3-bin

RUN cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar ${HIVE_HOME}/lib/

#RUN curl -L https://apache.org/dist/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
# RUN curl -L https://downloads.apache.org/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz | tar zxf - && \
#     curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz |   tar zxf - && \
#     curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz | tar zxf - && \
#     cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar ${HIVE_HOME}/lib/ && \
#     rm -rf  mysql-connector-java-8.0.19

COPY conf/hive-site.xml ${HIVE_HOME}/conf
COPY scripts/entrypoint.sh /entrypoint.sh

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh

USER hive
EXPOSE 9083

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
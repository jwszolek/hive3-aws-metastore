## Hive3 AWS Metastore

### Intro
Running Hive locally can present challenges, particularly when dealing with differing library versions and absent JAR files. In my research, I grappled with setting up a local Hive instance that stores data in a specific S3 bucket on AWS. My primary objective was to establish a functional environment for experimentation.

**Note: Docker-compose-based setups are not intended for production environments. They should be managed on Kubernetes. This setup was created solely for testing purposes.**

### Build

Follow the steps below to build and run this setup.

1. Modify the hive-site.xml file as shown below.

```
  <property>
        <name>fs.s3a.access.key</name>
        <value>REPLACE_ME</value>
    </property>
    <property>
        <name>fs.s3a.secret.key</name>
        <value>REPLACE_ME</value>
    </property>
    <property>
```

2. Build the metaservice container.
``` docker build -f Dockerfile.metas -t hive-meta:latest . ```

3. Build the metaservice container.
``` docker build -f Dockerfile.hs2 -t hive-hs2:latest . ```



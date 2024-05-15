FROM python:3.11-slim 

ARG shared_workspace=/mapd-workspace
ENV SHARED_WORKSPACE=${shared_workspace}

ENV PIP_DEFAULT_TIMEOUT=100 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
		PIP_NO_CACHE_DIR=1

# -- Layer: java
RUN mkdir -p /usr/share/man/man1
RUN apt-get -y update && \
    apt-get install --no-install-recommends -y \
    curl procps \
    "openjdk-17-jre-headless" \
    ca-certificates-java && \
    rm -rf /var/lib/apt/lists/*

# -- Layer: spark
ARG spark_version=3.5.1
ARG hadoop_version=3

RUN curl https://dlcdn.apache.org/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs && \
    rm spark.tgz && \
    apt-get -y remove curl && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*


ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV PYSPARK_PYTHON python
ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
ENV PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH

# -- Install pyarrow
RUN pip install pyarrow py4j pandas==1.5.3 psutil

# -- clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

FROM centos:centos7

# PROXY
ARG proxy
ENV http_proxy="$proxy"
ENV https_proxy="$proxy"

ARG DOCKER_PIP_VERSION="19.3.1"
ARG SETUPTOOLS_VERSION="41.6.0"
ENV INSIDE_CONTAINER="True"
ENV ANSIBLE_BECOME_FLAGS="-H -S -n -E"

COPY yum_packages.txt yum_packages.txt
RUN yum makecache fast && \
    yum install -y epel-release wget && \
    xargs yum install -y < yum_packages.txt && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN python -m pip install --no-cache-dir pip==$DOCKER_PIP_VERSION && \
    python -m pip install --no-cache-dir setuptools==$SETUPTOOLS_VERSION

RUN python3 -m pip install --no-cache-dir pip==$DOCKER_PIP_VERSION
RUN python3 -m pip install --no-cache-dir setuptools==$SETUPTOOLS_VERSION

COPY python3_libs.txt python3_libs.txt
RUN python3 -m pip install --no-cache-dir -r python3_libs.txt

COPY python2_libs.txt python2_libs.txt
RUN python -m pip install --no-cache-dir -r python2_libs.txt

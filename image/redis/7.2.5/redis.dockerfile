# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install system packages.
RUN yum install -y tcl

# Download and Extract redis.
WORKDIR /tmp
RUN set -x \
  && wget https://download.redis.io/releases/redis-7.2.5.tar.gz --quiet \
  && tar -xzvf redis-7.2.5.tar.gz > /dev/null

# Compile and Install Redis.
WORKDIR redis-7.2.5
RUN set -x \
  && make distclean \
  && make \
  && make install

# Create Redis directories.
RUN set -x \
  && mkdir /opt/redis \
  && mkdir /opt/redis/data \
  && mkdir /opt/redis/log \
  && mkdir /opt/redis/conf \
  && mkdir /opt/redis/script \
  && mkdir /opt/redis/system \
  && touch /opt/redis/system/server.pid \
  && touch /opt/redis/system/supervisor.ini \
  && ln -s /opt/redis/system/supervisor.ini /etc/supervisord.d/redis.ini \
  && rm -rf /tmp/redis-7.2.5* \
  && history -c

# Set default work directory.
WORKDIR /opt/redis
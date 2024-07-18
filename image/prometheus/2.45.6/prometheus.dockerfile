# Set the Docker image to use.
FROM sloopstash/base:v1.1.1
  
# Download and extract prometheus.
WORKDIR /tmp
RUN set -x \
  && wget https://github.com/prometheus/prometheus/releases/download/v2.45.6/prometheus-2.45.6.linux-amd64.tar.gz --quiet \
  && tar xvzf prometheus-2.45.6.linux-amd64.tar.gz > /dev/null

#compile and install prometheus.
WORKDIR prometheus-2.45.6.linux-amd64
RUN set -x \
  && cp prometheus /usr/local/bin/ \
  && cp promtool /usr/local/bin/

#create directories for prometheus
RUN set -x \
  && mkdir /opt/prometheus \
  && mkdir /opt/prometheus/data \
  && mkdir /opt/prometheus/log \
  && mkdir /opt/prometheus/conf \
  && mkdir /opt/prometheus/script \
  && mkdir /opt/prometheus/system \
  && mkdir /opt/prometheus/console_libraries \
  && mkdir /opt/prometheus/consoles \
  && touch /opt/prometheus/system/server.pid \
  && touch /opt/prometheus/system/supervisor.ini \
  && ln -s /opt/prometheus/system/supervisor.ini /etc/supervisord.d/prometheus.ini \
  && cp -r consoles/* /opt/prometheus/consoles \
  && cp -r console_libraries/* /opt/prometheus/console_libraries \
  && cd ../ \
  && rm -rf prometheus-2.45.6.linux* \
  && history -c

# Set default work directory.
WORKDIR /opt/prometheus

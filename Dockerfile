#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM openjdk:8-jre

ENV URL https://artifacts.elastic.co/downloads/elasticsearch
ENV ES_PKG_NAME elasticsearch-5.6.3

# Install Elasticsearch.
RUN \
  cd /tmp && \
  wget $URL/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv $ES_PKG_NAME /elasticsearch

# Define default command.
# CMD ["/elasticsearch/bin/elasticsearch", "-E", "logger.org.elasticsearch=trace", "-E", "network.bind_host=0.0.0.0", "-v"]

CMD ["/elasticsearch/bin/elasticsearch", "-E", "network.bind_host=0.0.0.0"]
# without this bind, ES can not accept traffic from out of container (it can accept traffic from inside container)

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

RUN useradd -m -d /home/esuser -s /bin/bash esuser
RUN usermod -aG sudo esuser
RUN chown -R esuser: /elasticsearch
USER esuser
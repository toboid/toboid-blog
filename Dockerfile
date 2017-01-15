FROM ruby:2.3.1

COPY . /app
WORKDIR /app

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.7.2
RUN ./bin/install-node

RUN apt-get update; apt-get install -y locales
RUN echo "en_GB UTF-8" > /etc/locale.gen
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN ./bin/setup
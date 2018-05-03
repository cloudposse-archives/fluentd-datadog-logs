FROM fluent/fluentd:v1.2

COPY ./rootfs .

ENV DATADOG_API_KEY=
ENV DATADOG_SERVICE_NAME=
ENV DATADOG_SOURCE_NAME=
ENV DATADOG_SERVICE_CATEGORY=
ENV DATADOG_LOG_SET=

USER root
WORKDIR /home/fluent
ENV PATH /fluentd/vendor/bundle/ruby/2.4.0/bin:$PATH
ENV GEM_PATH /fluentd/vendor/bundle/ruby/2.4.0
ENV GEM_HOME /fluentd/vendor/bundle/ruby/2.4.0
# skip runtime bundler installation
ENV FLUENTD_DISABLE_BUNDLER_INJECTION 1

RUN set -ex \
    && apk upgrade --no-cache \
    && apk add --no-cache ruby-bundler \
    && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev \
        libffi-dev \
    && gem install bundler --version 1.16.1 \
    && bundle config silence_root_warning true \
    && bundle install --gemfile=/fluentd/Gemfile --path=/fluentd/vendor/bundle \
    && apk del .build-deps \
    && gem sources --clear-all \
    && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# Environment variables
ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

# jemalloc is memory optimization only available for td-agent
# td-agent is provided and QA'ed by treasuredata as rpm/deb/.. package
# -> td-agent (stable) vs fluentd (edge)
#ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"

# Run Fluentd
CMD ["/fluentd/entrypoint.sh"]

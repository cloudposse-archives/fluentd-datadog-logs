#!/bin/sh

set -e

fluentd -c /fluentd/etc/${FLUENTD_CONF} -p /fluentd/plugins --gemfile /fluentd/Gemfile ${FLUENTD_OPT}
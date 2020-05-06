# Checkout and build GEM as long as stable GEM is not usable for monolith or current Ruby
FROM ruby:2.7-alpine AS builder

# Install all build dependencies
RUN apk update \
    && apk add --no-cache \
        git

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

RUN git clone https://github.com/rubysec/bundler-audit.git .
# TODO: use master when it can correctly handle new thor in monolith
RUN git checkout 0.7.0

RUN gem build bundler-audit.gemspec

# Install GEM
FROM ruby:2.7-alpine

# Install all build dependencies
RUN apk update \
    && apk add --no-cache \
        git

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

# Do not explicite version, value should hopefully change from 0.6.1 to 0.7.0
COPY --from=builder /usr/src/app/bundler-audit-*.gem .
COPY run_bundler_audit.sh /usr/src/run_bundler_audit.sh

RUN gem install bundler-audit-*.gem

ENTRYPOINT /bin/ash /usr/src/run_bundler_audit.sh

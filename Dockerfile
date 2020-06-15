FROM ruby:2.7-alpine

# Install all build dependencies
RUN apk update \
    && apk add --no-cache \
        git

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir /usr/src/laboratory
# Create dummy Gemfile, otherwise audit will fail
RUN touch /usr/src/laboratory/Gemfile
WORKDIR /usr/src/app

COPY iterate_bundle_audit_list.sh /usr/local/bin/iterate_bundle_audit_list.sh
COPY iterate_bundler_audit.sh /usr/local/bin/iterate_bundler_audit.sh
COPY docker_image_bundler_audit.sh /usr/local/bin/docker_image_bundler_audit.sh
COPY tar_bundler_audit.sh /usr/local/bin/tar_bundler_audit.sh

RUN gem install bundler-audit

ENTRYPOINT /bin/ash /usr/local/bin/iterate_bundler_audit.sh

#!/usr/bin/env sh
# Audit Ruby bundles in docker images

if [ -z "${docker_image}" ]; then
  echo "Error: Provide environment variable docker_image"
  exit 1
fi
if [ -z "${bundle_audit_image}" ]; then
  bundle_audit_image=movex/bundler-audit-image
fi
if [ -z "${GEMFILE_LOCK_PATTERN}" ]; then
  GEMFILE_LOCK_PATTERN=Gemfile*.lock
fi

# Create container from image to be checked,
# export gemfiles and lock files as tar ignoring errors,
# extract them in bundle-audit-image container and check
cmd_tar="find / \\( -name \"Gemfile\" -o -name \"${GEMFILE_LOCK_PATTERN}\" \\) -exec tar -c -T {} 2>/dev/null \+"
docker run --rm --entrypoint sh ${docker_image} -c "${cmd_tar}" | docker run --rm -i --entrypoint sh "${bundle_audit_image}" -c "tar_bundler_audit.sh"

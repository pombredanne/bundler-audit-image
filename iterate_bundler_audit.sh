#!/usr/bin/env sh
# Finds all Gemfile*.lock and audits.
# Returns 0 if no vulnerability was found. Otherwise returns an error code.
bundle-audit update

if [ -z "${GEMFILE_LOCK_PATTERN}" ]; then
  GEMFILE_LOCK_PATTERN=Gemfile*.lock
fi

find -L . -name "${GEMFILE_LOCK_PATTERN}" -type f -exec sh '/usr/local/bin/iterate_bundle_audit_list.sh' {} \+

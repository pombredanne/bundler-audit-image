#!/usr/bin/env bash
bundle-audit update

# find all Gemfile*.lock and check
if [[ -z "${GEMFILE_LOCK_PATTERN}" ]]; then
  GEMFILE_LOCK_PATTERN=Gemfile*.lock
fi
find . -name "${GEMFILE_LOCK_PATTERN}" -exec bundle-audit check --gemfile-lock={} \;

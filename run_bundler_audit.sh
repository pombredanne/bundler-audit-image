#!/usr/bin/env bash
if [[ -z "${GEMFILE_LOCK}" ]]; then
  GEMFILE_LOCK=Gemfile.lock
fi
bundle-audit check --update --gemfile-lock=${GEMFILE_LOCK}

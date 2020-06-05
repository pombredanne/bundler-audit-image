#!/usr/bin/env sh
# Iterates over a list of gemfile lock files provided as array argument.
# Returns 0 if no vulnerability was found. Otherwise returns an error code.
gemfile_list="${@}"

iterate_bundle_audit_check(){
  result=0
  arr="${@}"
  echo "Gemfile lock files to check: ${arr}"
  for val in ${arr}; do
    bundle_audit_check "${val}"
    rc_l=$?
    if [ ${rc_l} -ne 0 ]; then
      result=${rc_l}
    fi
  done
  return ${result}
}

bundle_audit_check(){
  echo "Bundle audit check file: ${1}"
  gemfile_lock="$(realpath ${1})"
  old_dir=$(pwd)
  cd "$(dirname ${gemfile_lock})"
  bundle-audit check --gemfile-lock="$(basename ${gemfile_lock})"
  rc=$?
  cd ${old_dir}
  return ${rc}
}

iterate_bundle_audit_check "${gemfile_list}"

#!/usr/bin/env sh
# Iterates over a list of gemfile lock files provided as array argument.
# Returns 0 if no vulnerability was found. Otherwise returns an error code.
gemfile_list="${@}"
laboratory='/usr/src/laboratory'
lab_gemfile_lock="${laboratory}/Gemfile.lock"

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
  # copy and rename gemfile and its lock file
  cp "${gemfile_lock}" "${lab_gemfile_lock}"
  old_dir=$(pwd)
  cd "${laboratory}"
  bundle-audit check
  rc=$?
  # clean up laboratory
  rm "${lab_gemfile_lock}"
  cd ${old_dir}
  return ${rc}
}

iterate_bundle_audit_check "${gemfile_list}"

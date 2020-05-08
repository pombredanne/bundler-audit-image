#!/usr/bin/env bash
# Finds all Gemfile*.lock and audits
bundle-audit update

if [[ -z "${GEMFILE_LOCK_PATTERN}" ]]; then
  GEMFILE_LOCK_PATTERN=Gemfile*.lock
fi

# Command as string
read -d '' cmd_str << EOF
val={} && 
gemfile_lock=\"\$(realpath \${val})\" && 
cd \"\$(dirname \${gemfile_lock})\" && 
bundle-audit check --gemfile-lock=\"\$(basename \${gemfile_lock})\"
EOF

# Find lock files and run audit
find -L . -name "${GEMFILE_LOCK_PATTERN}" -type f -exec sh -c "${cmd_str}" \;

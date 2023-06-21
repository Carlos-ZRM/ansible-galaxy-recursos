#!/usr/bin/env bash
# Requires Bash v4+
# Gathers Ansible facts for local Linux users from /etc/passwd, and optionally /etc/shadow.
# Place this under /etc/ansible/facts.d/ on your remote hosts,
# and make it executable. Ansible will save user info under the 'ansible_local' fact,
# whenever a playbook gathers facts.

# You can toggle whether to also include password expiration data from /etc/shadow.
# THIS REQUIRES ROOT PRIVILEGES TO WORK, or else empty / '0' results will be returned.
gather_shadow=true

readarray -t passwd_list < <(getent passwd)
readarray -t passwd_users < <(getent passwd | cut -d: -f1)

[ -r /etc/shadow ] && file_readable="true" || file_readable="false"

let "lastitem = ${#passwd_list[@]} - 1"

if ${gather_shadow}; then

  echo "{"
  for index in "${!passwd_list[@]}"; do
    
    # Parse the standard passwd data
    IFS=: read -r user pass uid gid description homedir shell <<< "${passwd_list[$index]}"
    # If user is not found in shadow DB, or if we don't have permissions to read, we return empty data.
    shadow_data=$(getent shadow "${user}" || echo '::::::::')
    IFS=: read -r shadowuser pwhash lastchg minage maxage warn inactive expires misc <<< "${shadow_data}"
    # 'present' is our clue to the user that we couldn't fetch the data from shadow, whatever the reason.
    [ -n "${shadowuser}" ] && present="true" || present="false"
    # Last element in the list should skip the comma at the end
    [ ${index} -eq ${lastitem} ] && delim='' || delim=','
    
    # Don't mess with the heredoc EOF spacing or Bash will cry
    cat << EOF
    "${user}": {
      "name": "${user}",
      "uid": ${uid},
      "gid": ${gid},
      "description": "${description}",
      "home": "${homedir}",
      "shell": "${shell}",
      "shadow": {
        "db_readable": ${file_readable},
        "user_found": ${present},
        "last_change": ${lastchg:-0},
        "min_age": ${minage:-0},
        "max_age": ${maxage:-0},
        "warn": ${warn:-0},
        "inactive": ${inactive:-0},
        "expires": ${expires:-0}
      }
    }${delim}
EOF
  done
  echo "}"

else

  echo "{"
  for index in "${!passwd_list[@]}"; do
    IFS=: read -r user pass uid gid description homedir shell <<< "${passwd_list[$index]}"
    [ ${index} -eq ${lastitem} ] && delim='' || delim=','
    # Don't mess with the heredoc EOF spacing or Bash will cry
    cat << EOF
    "${user}": {
      "name": "${user}",
      "uid": ${uid},
      "gid": ${gid},
      "description": "${description}",
      "home": "${homedir}",
      "shell": "${shell}"
    }${delim}
EOF
  done
  echo "}"

fi
#!/usr/bin/env bash
# Requires Bash v4+

#readarray -t virsh_lista_dominios < <(virsh list --all --name)
readarray -t virsh_lista_dominios < <(virsh list --all)

let "length_lista_dominios = ${#virsh_lista_dominios[@]} - 1"

echo $length_lista_dominios

echo "{"

for index in "${!virsh_lista_dominios[@]}"; do
  IFS=: read -r -d '    ' id name state <<< "$( echo virsh_lista_dominios[$index] )"
  cat << EOF
    "${name}": {
      "id": "${id}",
      "state": ${state},
    }${delim}
EOF

done

echo "}"
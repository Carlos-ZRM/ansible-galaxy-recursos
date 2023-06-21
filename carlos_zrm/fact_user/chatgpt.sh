#!/bin/bash

echo "{"

#!/bin/bash

# Obtener los protocolos únicos
protocols=$(netstat -tuln | tail -n +2 | awk '{print $1}' | grep -v "Proto" | sort -u)

protocols_limit=$(echo "$protocols" | wc -w)
protocols_count=0

for protocol in $protocols
do
  
  echo "  \"netstat_$protocol\":["  
  netstat_output=$(sudo netstat -pantu | awk -v protocol="$protocol" '$1 == protocol {print}')
  netstat_output_limit=$(sudo netstat -pantu | awk -v protocol="$protocol" '$1 == protocol {print}'  | wc -l)
  netstat_output_count=0
  parsed_output=$(echo "$netstat_output" | awk '{print $1, $2, $3, $4, $5, $6, $7}')
  while IFS= read -r line; do
  # Separate the line into variables
    
    read -r protocol recvq sendq local_address foreign_address state pid_program <<< "$line"
    if [ -z "$pid_program" ]; then
      pid_program=$state
      state=""
    fi
    str_echo_protocol="    {\"local_addr\":\"$local_address\",\"foreign_addr\":\"$foreign_address\",\"state\":\"$state\",\"pid_program\":\"$pid_program\"}"

    netstat_output_count=$((netstat_output_count + 1))
    if [ "$netstat_output_count" -eq "$netstat_output_limit" ]; then
      echo "$str_echo_protocol"
    else
      echo "$str_echo_protocol,"

    fi

  done <<< "$parsed_output"
  
  protocols_count=$((protocols_count + 1))
  if [ "$protocols_count" -eq "$protocols_limit" ]; then
    echo "  ]"
  else
    echo "  ],"
  fi

  
done

echo "}"
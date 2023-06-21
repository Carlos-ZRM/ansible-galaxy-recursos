# Creación del Script

Obtenemos la lista de elementos (dominios) , la longitud de elementos e imprimimos los caracteres `{}` para indicar el inicio y final del fact 
~~~ bash

readarray -t virsh_lista_dominios < <(virsh list --all --)

let "length_lista_dominios = ${#virsh_lista_dominios[@]} - 1"

echo $length_lista_dominios

echo "{"
echo "}"

~~~

    "jboss-eap": {
      "name": "jboss-eap",
      "uid": 1008,
      "gid": 100,
      "description": "",
      "home": "/home/jboss-eap",
      "shell": "/bin/bash",
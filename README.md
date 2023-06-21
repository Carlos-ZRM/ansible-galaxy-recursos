# ansible-galaxy-recursos

## Crear coleccion

~~~ bash
ansible-galaxy collection init carlos_zrm.system_discovery
~~~


~~~ bash
cd carlos_zrm/system_discovery/

~~~

Uncomment this line in `meta/runtime` and put the minimal ansible version required

`requires_ansible: '>=2.9.10'`

For create a rol
~~~ bash
cd roles
ansible-galaxy role init report_system
~~~


#!/bin/python3
import pkg_resources
import json

def get_installed_packages():
    # Obtener los paquetes instalados
    packages = pkg_resources.working_set

    # Crear una lista de diccionarios con los detalles de cada paquete
    package_list = []
    for package in packages:
        package_info = {
            'name': package.project_name,
            'version': package.version,
            'location': package.location
        }
        package_list.append(package_info)

    return package_list

if __name__ == "__main__":
    # Obtener la lista de paquetes instalados
    installed_packages = get_installed_packages()

    # Convertir la lista en formato JSON
    json_output = json.dumps(installed_packages, indent=4)

    # Imprimir el resultado
    print(json_output)

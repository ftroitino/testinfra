#!/bin/bash
#Genera los checks en python de los services para poder ser usados con el modulo check_service
#$1: Lista de procesos sacados de /etc/init.d/m2m. 

while read line; do

	nombreRPM=$(echo "$line\n" | sed 's/^-*//' | sed 's/-/_/g' | sed 's/\./_/g')
	#version=$(echo "$line\n" | grep -o '[1-9]\.[1-9]' | sed -n '1p' )
	nombreCompleto=$(echo "$line")

	echo "def test_$nombreRPM(Service):"
    echo "    servicio = Service('$nombreCompleto')"
    echo "    assert servicio.is_running"

done < $1
#!/bin/bash

while read line; do

    nombreRPMParseado=$(echo "$line\n" | grep -o '\-[a-z\-]*\-' | sed 's/.$//g' | sed 's/^-*//' | sed 's/-/_/g')
    nombreRPM=$(echo "$line\n" | grep -o '\-[a-z\-]*\-' | sed 's/.$//g' | sed 's/^-*//')
    version=$(echo "$line\n" |grep -o '[0-9]\.[0-9]\.[0-9]' | sed -n '1p' )
    nombreCompleto=$(echo "$line")

    echo "def test_$nombreRPMParseado(Package):"
    echo "    pack = Package(\"m2m-$nombreRPM-$version\")"
    echo "    assert pack.is_installed"
    echo "    assert pack.version.startswith(\"$version\")"

done < $1
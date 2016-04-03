##################################
Testinfra test your infrastructure
##################################

El repo origina es:

https://github.com/philpep/testinfra.git

Lo he cambiado para que permita añadir una password para conectarse a las maquinas.

Y he añadido los siguientes modulos:

- Ip_Port
- Mount
- Http
- Process
- RepoYum



Instalacion
============
   Instalar pyton 2.7:

   repo rh6:
      [python27]
      name=python27
      baseurl=http://artifactory.hi.inet/artifactory/simple/yum-m2m-release/python/rhel6/2.7/
      gpgcheck=0
      enabled=1

   repo rh5:
      baseurl=http://artifactory.hi.inet/artifactory/simple/yum-m2m-release/python/rhel5/2.7/

   yum install python27 python27-pip python27-devel git

   Instalar dependencias:

    pip2.7 install paramiko

    pip2.7 install pycrypto

    pip2.7 install six pytest

    python2.7 setup.py install


   Instalar el propio testinfra:

    git clone git@pdihub.hi.inet:troitino/testinfra.git
    cd testinfra && sudo python2.7 setup.py install


El testinfra dentro de la maquina se instala en:

/usr/lib/python2.7/site-packages/testinfra

Crear nuevos modulos
====================

Ir al directorio modules

Copiar un modulo al nuevo que vayamos a crear:

cp Group.py Nuevo.py

Y añadir el nuevo modulo a los ficheros:

./modules/__init__.py

./plugin.py

generator.sh: Script para generar checks.

checkGenerator.py: Script con fabric que genera los checks de la máquina que le pasemos como argumento.

		fab -f checkGenerator.py -H USERNAME@HOST generar --password=CONTRASEÑA

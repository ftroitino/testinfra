#!/bin/bash
# ./generator.sh -p "http://proxy2pdi.service.dsn.inet:6666" > corework1_mirror_all.py



function print_totales()
{
  echo -e "def test_md5_$1(Execute):"
  echo -e "\t comando=Execute(\"if [ \\\"$2\\\" != \\\"\$($3)\\\" ]; then exit 1;fi\")"
  echo -e "\t assert comando.isOk"
  echo -e ""
}


echo -e "#CHECK SELINUX"

print_totales "selinux" `sestatus | md5sum| cut -b-32` "sudo  /usr/sbin/sestatus | md5sum | cut -b-32"

echo -e "#CHECK DE PAQUETES"

print_totales "paquetes" `rpm -qa |  sed -e '/^m2m-/ d' | sort | md5sum | cut -b-32` "rpm -qa | sed -e '/^m2m-/ d' | sort | md5sum | cut -b-32"

echo -e "#CHECK DE SERVICIOS"

#print_totales "servicios1" `puppet resource service | md5sum| cut -b-32` "sudo puppet resource service | md5sum | cut -b-32"
print_totales "servicios2" `chkconfig --list | md5sum | cut -b-32` "sudo /sbin/chkconfig --list | md5sum | cut -b-32"


echo -e "#CHECK DE REPOS DE YUM"
print_totales "repos_yum" `cat /etc/yum.repos.d/*.repo | md5sum | cut -b-32` "cat /etc/yum.repos.d/*.repo | md5sum | cut -b-32"

echo -e "#CHECK PUNTOS DE MONTAJE"
print_totales "puntos_montaje" `mount  |  awk -v FS="( on | type)" '{print $2}' | md5sum | cut -b-32` "mount  |  awk -v FS=\\\"( on | type)\\\" '{print \$2}' | md5sum | cut -b-32"

echo -e "#CONEXIONES ABIERTAS"
print_totales "conexiones_abiertas" `netstat -tulpn | egrep -v 'Local Address|Internet connections' | md5sum | cut -b-32` "sudo netstat -tulpn | egrep -v \\\"Local Address|Internet connections\\\" | md5sum | cut -b-32"

echo -e "#USUARIOS"
print_totales "usuarios" `cat /etc/passwd | md5sum | cut -b-32` "cat /etc/passwd | md5sum | cut -b-32"

echo -e "#GRUPOS"
print_totales "grupos" `cat /etc/group | md5sum | cut -b-32` "cat /etc/group | md5sum | cut -b-32"

echo -e "#CRONTAB de USUARIOS"
for i in `cat /etc/passwd | awk -F':' '{ print $1}' | sort`
do
  print_totales "crontab_usuario_`echo $i | sed  "s/-/_/g"`" `sudo crontab -u $i -l | md5sum | cut -b-32` "sudo crontab -u $i -l | md5sum | cut -b-32"
done

# echo -e "#Procesos por USUARIOS"
# for i in `cat /etc/passwd |grep -v haldaemon | awk -F':' '{ print $1}' | sort`
# do
#   print_totales "procesos_usuario_`echo $i | sed  "s|/|_|g" | sed  "s|\.|_|g" | sed  "s|-|_|g"`" `sudo /bin/ps -u $i | column -t | awk '{print $4}' | egrep -v "CMD|generator.sh|puppet|awk|grep|egrep|bash|column|sort|uniq|ssh|sftp-server|tail|sleep|cyclops|kslowd" | sort | uniq|md5sum | cut -b-32` "sudo /bin/ps -u $i | column -t | awk '{print $4}' | egrep -v \\\"CMD|generator.sh|puppet|awk|grep|egrep|bash|column|sort|uniq|ssh|sftp-server|tail|sleep|cyclops|kslowd\\\" | sort | uniq|md5sum | cut -b-32"
# done
#
# echo -e "#ficheros abiertos por el USUARIOS"
# for i in `cat /etc/passwd |grep -v haldaemon | awk -F':' '{ print $1}' | sort`
# do
#   print_totales "ficheros_abiertos_`echo $i | sed  -e "s|/|_|g" -e "s|\.|_|g" -e "s|-|_|g" -e "s|\@|_|g"`"  `sudo lsof -u $i -a | grep "   REG  " | egrep -v "anon_inode|eventpoll|\[|lib" | grep -v "(deleted)" | column -t | awk '{print $9}' | sort | uniq | sed "/^$/d" | sed -e "/^\/bin\// d" -e "/^\/tmp\// d" -e "/^\/proc\// d" -e "/^\/sbin\// d" -e "/^\/usr\/bin\// d" -e "/^\/usr\/sbin\// d"| egrep -v "[0-9]{4}-[0-9]{2}-[0-9]{2}"|md5sum | cut -b-32` "sudo lsof -u $i -a | grep \\\"   REG  \\\" | egrep -v \\\"anon_inode|eventpoll|\[|lib\\\" | grep -v \\\"(deleted)\\\" | column -t | awk '{print $9}' | sort | uniq | sed '/^$/d' | sed -e '/^\/bin\// d' -e '/^\/tmp\// d' -e '/^\/proc\// d' -e '/^\/sbin\// d' -e '/^\/usr\/bin\// d' -e '/^\/usr\/sbin\// d'| egrep -v \\\"[0-9]{4}-[0-9]{2}-[0-9]{2}\\\"|md5sum | cut -b-32"
# done

#!/bin/bash
# ./generator.sh -p "http://proxy2pdi.service.dsn.inet:6666" > corework1_mirror_all.py

function print_selinux()
{
  echo -e "def test_selinux_$1(Selinux):"
  echo -e "\t selinux = Selinux()"
  if [ "$1" == "disabled" ]
  then
     echo -e "\t assert selinux.is_disabled"
  fi
  if [ "$1" == "enforcing" ]
  then
     echo -e "\t assert selinux.is_enforcing"
  fi
}

function print_procces_for_user()
{
  echo -e "def test_exists_procces_$3_in_user_$1(Execute):"
  echo -e "\t comando=Execute(\"sudo /bin/ps -edf | grep '$2' | grep '$4' | grep -v grep\")"
  echo -e "\t assert comando.isOk"
  echo -e ""
}

#function  print_files_open_to_user()
#{
#  echo -e "def test_exists_file_$3_to_user_$1(File):"
#  echo -e "\t fichero=File(\"$4\")"
#  echo -e "\t assert fichero.exists"
#  echo -e "\t assert fichero.is_file"
#  echo -e "\t if fichero.user != '$2':"
#  echo -e "\t\t assert False"
#  echo -e ""
#  echo -e ""
#}

function  print_files_open_to_user()
{
  echo -e "def test_exists_file_$3_to_user_$1(Execute):"
  #echo -e "\t comando=Execute(\"sudo /usr/bin/test -f $4\")"
  echo -e "\t comando=Execute(\"sudo su -s /bin/sh -c  'test -r $4' $2\")"
  echo -e "\t assert comando.isOk"
  echo -e ""
}

function  print_files_is_of_user()
{
  echo -e "def test_file_$2_is_of_user_$1(Command):"
  echo -e "\t comando = Command(\"sudo stat -c %U $3\")"
  echo -e "\t result_=\"$1\""
  echo -e "\t if comando.stdout.rstrip('\\\n') != result_:"
  echo -e "\t\t assert False"
  echo -e ""
}

function print_crontab()
{
  echo -e "def test_exists_crontab_$1(Command):"
  echo -e "\t comando = Command(\"sudo crontab -u $2 -l | tr '\\\n' ' ' | sed 's/ /,/g' | sed 's/\\\"/_/g'\")"
  echo -e "\t result_=\"$3\""
  echo -e "\t if comando.stdout.rstrip('\\\n') != result_:"
  echo -e "\t\t assert False"
  echo -e ""
}

function print_usuario()
{
  echo -e "def test_exists_usuario_$1(User):"
  echo -e "\t usuario = User('$2')"
  echo -e "\t assert usuario.exists"
  echo -e "\t cadena_grupos =  \",\".join(str(x) for x in usuario.groups)"
  echo -e "\t home_=usuario.home"
  echo -e "\t shell_=usuario.shell"
  echo -e "\t if cadena_grupos != '$3':"
  echo -e "\t\t assert False"
  echo -e "\t if home_ != '$4':"
  echo -e "\t\t assert False"
  echo -e "\t if shell_ != '$5':"
  echo -e "\t\t assert False"
  echo -e ""
}


function print_grupo()
{
  echo -e "def test_exists_grupo_$1(Group):"
  echo -e "\t grupo = Group('$2')"
  echo -e "\t assert grupo.exists"
  echo -e ""
}

function print_ip_port()
{
  echo -e "def test_conexion_$1_$3(Ip_Port):"
  echo -e "\t conexion = Ip_Port('$2','$3')"
  echo -e "\t assert conexion.exists"
  echo -e ""
}

function print_package()
{
  echo -e "def test_exists_package_$1(Package):"
  echo -e "\t pack = Package('$2')"
  echo -e "\t assert pack.is_installed"
  echo -e ""
}

function print_service()
{
echo -e "def test_exists_service_$1(Service):"
echo -e "\t servicio = Service('$2')"
echo -e "\t assert servicio.is_running_sudo"
echo -e ""
}

function print_yum_repos ()
{
echo -e "def test_exists_yumrepo_$1(RepoYum):"
echo -e "\t url_yum_repo = RepoYum('$2',\"$proxy\")"
echo -e "\t assert url_yum_repo.exists"
echo -e ""
}

function print_mounts ()
{
echo -e "def test_exists_mount_$1(Mount):"
echo -e "\t mount = Mount('$2')"
echo -e "\t assert mount.exists"
echo -e ""
}



proxy=""
while getopts p: opts; do
   case ${opts} in
      p) proxy=${OPTARG} ;;
   esac
done


echo -e "#CHECK SELINUX"

print_selinux `sestatus | grep 'Current mode' | cut -d':' -f2 | sed -e 's/^[ \t]*//'`

echo -e "#CHECK DE PAQUETES"
for i in `rpm -qa | sed -e '/^m2m-/ d' | sort`
do
  print_package `echo $i | sed  "s/-/_/g" | sed "s/\./_/g" | sed "s/\+/_/g"` $i
done

echo -e "#CHECK DE SERVICIOS"
for i in `puppet resource service  | grep -B 1 running  | grep service | grep -v 'set_hostname' | cut -d' ' -f 3,4 | sed  "s/'//g"  | sed  "s/://g" | sort`
do
  print_service `echo $i | sed  "s/-/_/g" | sed "s/\./_/g"` $i
done

echo -e "#CHECK DE REPOS DE YUM"
counter=1
#for i in `grep baseurl /etc/yum.repos.d/*.repo | grep -v ftp | cut -d'=' -f2`
for i in `yum -v repolist enabled 2>/dev/null | grep Repo-baseurl| grep -v ftp | cut -d':' -f 2-`
do
  print_yum_repos $counter `echo -e "$i" | sed  's/\$basearch/x86_64/g'`
  let counter++
done

echo -e "#CHECK PUNTOS DE MONTAJE"
counter=1
for i in `mount  |  awk -v FS="( on | type)" '{print $2}'`
do
  print_mounts $counter $i
  let counter++
done

echo -e "#CONEXIONES ABIERTAS"
counter=1
for i in `netstat -tulpn | egrep -v "Local Address|Internet connections" | grep -v "::" | grep -v udp | column  -t |  awk '{print $4}' | egrep -v "127.0.0.1:60[0-9][0-9]"`
do
  ip=`echo -e "$i" | cut -d':' -f1`
  port=`echo -e "$i" | cut -d':' -f2`
  print_ip_port $counter $ip $port
  let counter++
done

echo -e "#USUARIOS"
for i in `cat /etc/passwd | awk -F':' '{ print $1}' | sort`
do
  grupos_=`id -nG $i | sed "s/ /,/g"`
  home_=`getent passwd $i | cut -d':' -f6`
  shell_=`getent passwd $i | cut -d':' -f7`
  print_usuario `echo $i | sed  "s/-/_/g"` $i $grupos_ $home_ $shell_
done

echo -e "#GRUPOS"
for i in `cut -d: -f1 /etc/group | sort`
do
  print_grupo `echo $i | sed  "s/-/_/g"` $i
done


echo -e "#CRONTAB de USUARIOS"
for i in `cat /etc/passwd | awk -F':' '{ print $1}' | sort`
do
  crontab_=`sudo crontab -u $i -l | tr '\\n' ' ' | sed 's/ /,/g' | sed 's/"/_/g'`
  print_crontab `echo $i | sed  "s/-/_/g"` $i $crontab_
done

echo -e "#Procesos por USUARIOS"
for i in `cat /etc/passwd |grep -v haldaemon | awk -F':' '{ print $1}' | sort`
do
  for j in `/bin/ps -u $i | column -t | awk '{print $4}' | egrep -v "CMD|generator.sh|puppet|awk|grep|egrep|bash|column|sort|uniq|ssh|sftp-server|tail|sleep|cyclops|kslowd" | sort | uniq`
  do
    print_procces_for_user `echo $i | sed  "s|/|_|g" | sed  "s|\.|_|g" | sed  "s|-|_|g"` $i `echo $j | sed  "s|/|_|g" | sed  "s|\.|_|g" | sed  "s|-|_|g" | sed  "s|:|_|g"` $j
  done
done


echo -e "#ficheros abiertos por el USUARIOS"
for i in `cat /etc/passwd |grep -v haldaemon | awk -F':' '{ print $1}' | sort`
do
 for j in `lsof -u $i -a | grep "   REG  " | egrep -v "anon_inode|eventpoll|\[|lib" | grep -v "(deleted)" | column -t | awk '{print $9}' | sort | uniq | sed '/^$/d' | sed -e '/^\/bin\// d' -e '/^\/tmp\// d' -e '/^\/proc\// d' -e '/^\/sbin\// d' -e '/^\/usr\/bin\// d' -e '/^\/usr\/sbin\// d'| egrep -v "[0-9]{4}-[0-9]{2}-[0-9]{2}"`
 do
   print_files_open_to_user `echo $i | sed  -e "s|/|_|g" -e "s|\.|_|g" -e "s|-|_|g" -e "s|\@|_|g"` $i `echo $j | sed  -e "s|/|_|g" -e "s|\.|_|g" -e "s|-|_|g" -e "s|:|_|g" -e "s|@|_|g"` $j
   #print_files_is_of_user $i `echo $j | sed  -e "s|/|_|g" -e "s|\.|_|g" -e "s|-|_|g" -e "s|:|_|g" -e "s|@|_|g"` $j
 done
done

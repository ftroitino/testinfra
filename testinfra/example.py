import pytest

def test_file_etc_fstab(File):
    file = File("/etc/mongod.conf")
    assert file.contains('port = 27017')  # todo make it a regex
    assert file.contains('dbpath=/var/lib/mongo')
    assert file.contains('nojournal = true')
    assert file.is_file

def test_command_output(Command):
    command = Command('redis-cli ping')
    assert command.stdout.rstrip() == 'PONG'
    assert command.rc == 0


def test_exists_usuario_root(User):
         usuario = User('root')
         assert usuario.exists
         cadena_grupos =  ",".join(str(x) for x in usuario.groups)
         assert cadena_grupos == 'root,bin,daemon,sys,adm,disk,wheel'
         assert usuario.home == '/root'
         assert usuario.shell == '/bin/bash'
         assert usuario.uid == 0
         assert usuario.gid == 0
         assert usuario.group == 'root'


def test_exists_grupo_sys(Group):
         grupo = Group('sys')
         assert grupo.exists
         assert grupo.gid == 3

def test_file_etc_fstab(File):
    file = File("/etc/fstab")
    assert file.exists
    assert file.is_file #test -f
    assert not file.is_directory #test -d
    assert not file.is_pipe # test -p
    assert not file.is_socket # test -S
    assert not file.is_symlink # test -L
    assert file.user == 'root'
    assert file.uid == 0
    assert file.mode == 644
    assert file.group == 'root'
    assert file.gid == 0
    assert file.mtime.strftime("%Y-%m-%d %H:%M:%S")== '2015-10-02 15:53:57'
    assert file.size == 1318
    assert file.md5sum == '42f21fec9f4c14895d0afea3ec5c3bca'
    assert file.sha256sum == '1fa2f49dabb16e0ffd2e6950e4da6a54953c25d1d58f7cb4cda3b58e9c5adee0'

def test_file_etc_fstab_content(File):
    file = File("/etc/fstab")
    assert file.exists
    assert file.is_file #test -f
    assert file.contains('//granero-boe.hi.inet/coreshared-01	/coreshared')
    contenido = file.content_string
    print contenido


def test_exists_mount_raiz(Mount):
    mount = Mount('rootfs / rootfs rw 0 0')
    assert mount.exists

def test_service_httpd_running_and_enabled(Service):
    servicio = Service("httpd")
    assert servicio.is_running
    assert servicio.is_enabled
    assert servicio.is_enabled_with_level(3)
    assert servicio.is_enabled_with_level(5)


def test_exists_yumrepo_1(RepoYum):
    url_yum_repo = RepoYum('http://artifactory.hi.inet/artifactory/yum-m2m-release/common/',)
    assert url_yum_repo.exists

def test_m2m_gs_api_base_is_installed(Package):
    pack = Package("m2m-gs-api-base")
    assert pack.is_installed
    assert pack.version.startswith("2.6.1")


def test_package_pip_flask_pymongo(Package_Pip):
    assert Package_Pip("pip3","Flask-PyMongo").exists


def test_selinux(Selinux):
    selinux = Selinux()
    assert selinux.is_disabled
    assert not selinux.is_enabled
    assert not selinux.is_permissive
    assert not selinux.is_enforcing


def test_puppet_resource_user_mongod(PuppetResource):
    papet = PuppetResource("user","mongod")
    assert papet['mongod']['ensure'] == 'present'
    assert papet['mongod']['home'] == '/var/lib/mongo'
    assert  papet['mongod']['shell'] == '/bin/false'



def test_sysctl(Sysctl):
   assert Sysctl("kernel.osrelease") == "2.6.18-406.el5"
   assert Sysctl("kernel.ostype") == "Linux"


def test_check_process_crond(Process):
   assert Process("crond").exists

def test_ip_0_0_0_0_port_6379(Ip_Port):
   assert  Ip_Port("0.0.0.0","6379").exists # redis server


def test_eth0(Interface):
    interface = Interface("eth0")
    assert interface.exists
    assert interface.addresses[0] == "10.95.7.121" #check ip
#    assert interface.addresses[1] == "fe80::250:56ff:fea6:25fb" #IP V6

def test_www_google_es(Http):
    assert Http("www.google.es").exists


def test_command_output(Command):
    command = Command('redis-cli ping')
    assert command.stdout.rstrip() == 'PONG'
    assert command.rc == 0



@pytest.mark.parametrize("name,version", [
    ("m2m-gs-api-base", "2.6.1"),
    ("python27", "2.7.9"),
])
def test_packages(Package, name, version):
    assert Package(name).is_installed
    assert Package(name).version.startswith(version)


def test_systeminfo(SystemInfo):
    assert SystemInfo.type == 'linux'
    assert SystemInfo.distribution == 'redhatenterpriseserver'
    assert SystemInfo.release == '5.11'
    assert SystemInfo.codename == 'tikanga'
    assert SystemInfo.user =='sysadmin'
    assert SystemInfo.uid == 528
    assert SystemInfo.group == 'sysadmin'
    assert SystemInfo.gid == 528
    assert SystemInfo.hostname == 'cloncloud-m2mglobserv02'

def test_facter(Facter):
    assert Facter("kernelversion") == {'kernelversion': '2.6.18'}
    assert Facter("is_virtual") == {'is_virtual': True}
    assert Facter("is_virtual")['is_virtual'] == True


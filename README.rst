###################################################
Testinfra: Permite realizar test de infraestructura
###################################################

Documentación: http://testinfra.readthedocs.org/en/latest

¿Que es testinfra?
==================

Con Testinfra puedes escribir pruebas unitarias para probar la configuración de tus servidores y por lo tanto que tu infraestructura es correcta

Es un plugin de Pytest, la programación es en python

Es un equivalente a Serverspec (Ruby)

Instalación
===========

Repo oficial::

    $ pip install testinfra

    # or install the devel version
    $ pip install 'git+https://github.com/philpep/testinfra@master#egg=testinfra'


Las actualizaciones de este repo::

   $ git clone git@github.com:ftroitino/testinfra.git

   $ cd testinfra && sudo python2.7 setup.py install

Ejemplos de test
################

Command::

    def test_command_output(Command):
        command = Command('redis-cli ping')
        assert command.stdout.rstrip() == 'PONG'
        assert command.rc == 0

Execute::

    def test_execute_ok(Execute):
        assert Execute('redis-cli ping').isOk

User::

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

Group::

    def test_exists_grupo_sys(Group):
             grupo = Group('sys')
             assert grupo.exists
             assert grupo.gid == 3

File::

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
        assert file.contains('//nfs.hi.inet/shared-01   /shared')
        contenido = file.content_string
        print contenido

Package::

    def test_m2m_gs_api_base_is_installed(Package):
        pack = Package("gs-api-base")
        assert pack.is_installed
        assert pack.version.startswith("2.6.1")

Pip::

    def test_package_pip_flask_pymongo(Package_Pip):
        assert Package_Pip("pip3","Flask-PyMongo").exists


Service::

    def test_service_httpd_running_and_enabled(Service):
        servicio = Service("httpd")
        assert servicio.is_running
        assert servicio.is_enabled
        assert servicio.is_enabled_with_level(3)
        assert servicio.is_enabled_with_level(5)


Repoyum::

    def test_exists_yumrepo_1(RepoYum):
        url_yum_repo = RepoYum('http://rpms.hi.inet/common/',)
        assert url_yum_repo.exists


Mount::

    def test_exists_mount_raiz(Mount):
        mount = Mount('rootfs / rootfs rw 0 0')
        assert mount.exists

Selinux::

    def test_selinux(Selinux):
        selinux = Selinux()
        assert selinux.is_disabled
        assert not selinux.is_enabled
        assert not selinux.is_permissive
        assert not selinux.is_enforcing

Puppetresource::

    def test_puppet_resource_user_mongod(PuppetResource):
        papet = PuppetResource("user","mongod")
        assert papet['mongod']['ensure'] == 'present'
        assert papet['mongod']['home'] == '/var/lib/mongo'
        assert  papet['mongod']['shell'] == '/bin/false'

Sysctl::

    def test_sysctl(Sysctl):
       assert Sysctl("kernel.osrelease") == "2.6.18-406.el5"
       assert Sysctl("kernel.ostype") == "Linux"

Process::

    def test_check_process_crond(Process):
       assert Process("crond").exists

IP_Port::

    def test_ip_0_0_0_0_port_6379(Ip_Port):
       assert  Ip_Port("0.0.0.0","6379").exists # redis server

Interface::

    def test_eth0(Interface):
        interface = Interface("eth0")
        assert interface.exists
        assert interface.addresses[0] == "192.95.7.121" #check ip
    #    assert interface.addresses[1] == "fe80::250:56ff:fea6:25fb" #IP V6

SystemInfo::

    def test_systeminfo(SystemInfo):
        assert SystemInfo.type == 'linux'
        assert SystemInfo.distribution == 'redhatenterpriseserver'
        assert SystemInfo.release == '5.11'
        assert SystemInfo.codename == 'tikanga'
        assert SystemInfo.user =='sysadmin'
        assert SystemInfo.uid == 528
        assert SystemInfo.group == 'sysadmin'
        assert SystemInfo.gid == 528
        assert SystemInfo.hostname == 'test02'

Facter::

    def test_facter(Facter):
        assert Facter("kernelversion") == {'kernelversion': '2.6.18'}
        assert Facter("is_virtual") == {'is_virtual': True}
        assert Facter("is_virtual")['is_virtual'] == True

Http::

    def test_www_google_es(Http):
        assert Http("www.google.es").exists


Parametrizar test::

    @pytest.mark.parametrize("name,version", [
        ("gs-api-base", "2.6.1"),
        ("python27", "2.7.9"),
    ])
    def test_packages(Package, name, version):
        assert Package(name).is_installed
        assert Package(name).version.startswith(version)

Ejecución
#########

Local::
 
    $ testinfra -v test_myinfra.py


    ====================== test session starts ======================
    platform linux -- Python 2.7.3 -- py-1.4.26 -- pytest-2.6.4
    plugins: testinfra
    collected 3 items

    test_myinfra.py::test_passwd_file[local] PASSED
    test_myinfra.py::test_nginx_is_installed[local] PASSED
    test_myinfra.py::test_nginx_running_and_enabled[local] PASSED

    =================== 3 passed in 0.66 seconds ====================

Remota::

    $ testinfra -v --hosts=user:password@maquina00,user:password@maquina01 /tmp/test_package_python_27.py


    ============================= test session starts ==============================
    platform linux2 -- Python 2.7.7, pytest-2.8.2, py-1.4.30, pluggy-0.3.1 -- /usr/bin/python2.7
    cachedir: ../tmp/.cache
    rootdir: /tmp, inifile: 
    plugins: testinfra-0.0.1.dev45
    collected 2 items 
    ../tmp/test.py::test_package_python27_exists[user:password@maquina00] PASSED
    ../tmp/test.py::test_package_python27_exists[user:password@maquina01] PASSED

Remota con usuario sudo::

    $ testinfra -v --sudo --hosts=sudo_user:password@maquina00,sudo_user:password@maquina01 /tmp/test_package_python_27.py


    ============================= test session starts ==============================
    platform linux2 -- Python 2.7.7, pytest-2.8.2, py-1.4.30, pluggy-0.3.1 -- /usr/bin/python2.7
    cachedir: ../tmp/.cache
    rootdir: /tmp, inifile: 
    plugins: testinfra-0.0.1.dev45
    collected 2 items 
    ../tmp/test.py::test_package_python27_exists[user:password@maquina00] PASSED
    ../tmp/test.py::test_package_python27_exists[user:password@maquina01] PASSED


referencias
###########

    Testinfra Original(Github): https://github.com/philpep/testinfra

    Testinfra modules: http://testinfra.readthedocs.org/en/latest/modules.html

    Salt: http://saltstack.com/

    Ansible: http://www.ansible.com/

    Puppet: https://puppetlabs.com/

    Chef: https://www.chef.io/

    Serverspec: http://serverspec.org/

    Pytest: http://pytest.org

from fabric.api import *
from fabric.api import run, get
from fabric.api import env
env.warn_only = True # if you want to ignore exceptions and handle them yurself


pathGenerator = '/home/develenv/app/hudson/jobs/testinfra_generarCHECKS/workspace/testinfra/util/generator.sh'
pathSalida = '/home/develenv/app/hudson/jobs/testinfra_generarCHECKS/workspace/resultado/'

def generar(filename):
    put(pathGenerator, '/tmp/util.sh', mode=0755)
    command = "/tmp/util.sh > /tmp/%s" %filename
    x = sudo(command)
    if(x.stderr != ""):
        error = "On %s: %s" %(command, x.stderr)
        print error
        print x.return_code # which may be 1 or 2
        # do what you want or
        print "Ha ocurrido un error."
    else:
        get("/tmp/%s" %filename, pathSalida) 
        print x.return_code # which is -1


# -*- coding: utf8 -*-
from __future__ import unicode_literals

from testinfra.modules.base import Module


class Connectivity(Module):
    """Test unix connectivity other ip and port"""

    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
        super(Connectivity, self).__init__()


    @property
    def exists(self):
        return self.run_expect([0], "/usr/bin/nc -v -w 1 %s -z %s",self.ip, self.port).rc == 0

    def __repr__(self):
        return "<ip: %s port: %s>" % (self.ip, self.port,)

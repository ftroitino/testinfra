# -*- coding: utf8 -*-
from __future__ import unicode_literals

from testinfra.modules.base import Module


class Ip_Port(Module):
    """Test unix Port Open"""

    def __init__(self, ip, port):
        self.ip = ip
        self.port = port
        super(Ip_Port, self).__init__()


    @property
    def exists(self):
        return self.run_expect([0], "cat < /dev/null > /dev/tcp/%s/%s",self.ip, self.port).rc == 0

    def __repr__(self):
        return "<ip: %s port: %s>" % (self.ip, self.port,)

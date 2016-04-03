# -*- coding: utf8 -*-
from __future__ import unicode_literals

from testinfra.modules.base import Module


class Port(Module):
    """Test unix Port Open"""

    def __init__(self, port):
        self.port = port
        super(Port, self).__init__()


    @property
    def exists(self):
        return self.run_expect([0], "cat < /dev/null > /dev/tcp/0.0.0.0/%s",self.port).rc == 0

    def __repr__(self):
        return "<port: %s>" % (self.port,)

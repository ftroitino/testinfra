# -*- coding: utf8 -*-

from __future__ import unicode_literals

from testinfra.modules.base import Module


class Process(Module):
    """Test unix process"""

    def __init__(self, name):
        self.name = name
        super(Process, self).__init__()

    @property
    def exists(self):
        return self.run_expect([0], "/sbin/pidof %s", self.name).rc == 0

    def __repr__(self):
        return "<process %s>" % (self.name,)

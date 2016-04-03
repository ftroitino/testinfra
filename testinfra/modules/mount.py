# -*- coding: utf8 -*-

from __future__ import unicode_literals

from testinfra.modules.base import Module


class Mount(Module):
    """Test unix mount point"""

    def __init__(self, name):
        self.name = name
        super(Mount, self).__init__()

    @property
    def exists(self):
        return self.run_expect([0], "/bin/grep %s /proc/mounts", self.name).rc == 0

    def __repr__(self):
        return "<mount %s>" % (self.name,)

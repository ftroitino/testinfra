# -*- coding: utf8 -*-
from __future__ import unicode_literals

from testinfra.modules.base import Module


class Package_Pip(Module):
    """Test unix Port Open"""

    def __init__(self, pip, package):
        self.pip = pip
        self.package = package
        super(Package_Pip, self).__init__()


    @property
    def exists(self):
        return self.run_expect([0], "/usr/bin/%s show %s | grep -i %s",self.pip, self.package, self.package).rc == 0

    def __repr__(self):
        return "<pip: %s package: %s>" % (self.pip, self.package,)

# -*- coding: utf8 -*-

from __future__ import unicode_literals

import pytest

from testinfra.modules.base import Module


class Package(Module):
    """Test packages status and version"""

    def __init__(self, name):
        self.name = name
        super(Package, self).__init__()

    @property
    def is_installed(self):
        #return self.run_test("rpm -q %s", self.name)
        return self.run_expect([0], "/bin/rpm -q %s", self.name).rc == 0

    @property
    def version(self):
        out = self.check_output("rpm -qi %s", self.name)

        # Name        : bash
        # Version     : 4.2.46
        # ...
        for line in out.splitlines():
            if line.startswith("Version"):
                return line.split(":", 1)[1].strip()
        raise RuntimeError("Cannot parse output '%s'" % (out,))

    def __repr__(self):
        return "<package %s>" % (self.name,)

# -*- coding: utf8 -*-

from __future__ import unicode_literals

from testinfra.modules.base import Module


class Selinux(Module):
    """Test unix group"""

    def __init__(self):
        super(Selinux, self).__init__()

    @property
    def is_disabled(self):
        return self.run_expect([0, 2], " /usr/sbin/sestatus | /bin/grep -i status | /bin/grep -i disabled").rc == 0


    @property
    def is_enabled(self):
        return self.run_test(" /usr/sbin/sestatus | /bin/grep -i status | /bin/grep -i enabled").rc == 0

    @property
    def is_permissive(self):
        return self.run_test(" /usr/sbin/sestatus | /bin/grep -i mode | /bin/grep -i permissive").rc == 0

    @property
    def is_enforcing(self):
        return self.run_test(" /usr/sbin/sestatus | /bin/grep -i mode | /bin/grep -i enforcing").rc == 0


    def __repr__(self):
        return "< selinux >"

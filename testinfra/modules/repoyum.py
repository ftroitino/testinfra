# -*- coding: utf8 -*-

from __future__ import unicode_literals

from testinfra.modules.base import Module


class RepoYum(Module):
    """Test unix repoyum"""

    def __init__(self, url, proxy=None):
        self.url = url
        self.proxy = proxy
        super(RepoYum, self).__init__()

    @property
    def exists(self):
        if self.proxy is None:
            return self.run_expect([0], "/usr/bin/curl --output /dev/null --silent --head --fail %s/repodata/repomd.xml", self.url).rc == 0
        
        else:
            return self.run_expect([0], "/usr/bin/curl --output /dev/null --silent --head --fail %s/repodata/repomd.xml --proxy %s", self.url, self.proxy).rc == 0


    def __repr__(self):
        return "<url: %s/repodata/repomd.xml> proxy: %s" % (self.url, self.proxy,)

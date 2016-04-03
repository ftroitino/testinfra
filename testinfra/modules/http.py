# -*- coding: utf8 -*-

from __future__ import unicode_literals

from testinfra.modules.base import Module


class Http(Module):
    """Test unix http conexion"""

    def __init__(self, url):
        self.url = url
        super(Http, self).__init__()

    @property
    def exists(self):
        return self.run_expect([0], "/usr/bin/curl --output /dev/null --silent --head --fail %s", self.url).rc == 0

    def __repr__(self):
        return "<url_http: %s>" % (self.url,)

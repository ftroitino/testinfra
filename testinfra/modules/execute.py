# -*- coding: utf8 -*-
# Copyright © 2015 Philippe Pepiot
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import unicode_literals

from testinfra.modules.base import Module


class Execute(Module):
    """Test execute command is correct"""

    def __init__(self, name):
        self.name = name
        super(Execute, self).__init__()

    @property
    def isOk(self):
        return self.run_expect([0],self.name).rc == 0
    def __repr__(self):
        return "<Execute %s>" % (self.name,)

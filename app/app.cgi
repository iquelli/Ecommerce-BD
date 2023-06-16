#!/usr/bin/python3

#
# 		File: proj.cgi
# 		Authors:
# 		        - Gonçalo Bárias (ist1103124)
# 		        - Raquel Braunschweig (ist1102624)
#               - Vasco Paisana (ist1102533)
# 		Group: 2
# 		Description: Entry point to the web app.

import sys

sys.path.insert(0, "~/.local/lib/python3.9/site-packages/")

from wsgiref.handlers import CGIHandler

from app import _app

CGIHandler().run(_app)

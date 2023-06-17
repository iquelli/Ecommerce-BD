#!/usr/bin/python3

#
# 		File: app.cgi
# 		Authors:
# 		        - Gonçalo Bárias (ist1103124)
# 		        - Raquel Braunschweig (ist1102624)
#               - Vasco Paisana (ist1102533)
# 		Group: 2
# 		Description: Entry point to the web app.

from wsgiref.handlers import CGIHandler

from app import _app

CGIHandler().run(_app)

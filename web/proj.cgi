#!/usr/bin/python3

#
# 		File: proj.cgi
# 		Authors:
# 		        - Gonçalo Bárias (ist1103124)
# 		        - Raquel Braunschweig (ist1102624)
#               - Vasco Paisana (ist1102533)
# 		Group: 2
# 		Description: Used to create the web app prototype.

from wsgiref.handlers import CGIHandler
from flask import Flask, render_template, request, redirect, url_for
import psycopg2
import psycopg2.extras

# SGBD configs
DB_HOST = "db"
DB_DATABASE = "postgres"
DB_USER = "postgres"
DB_PASSWORD = "postgres"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

app = Flask(__name__)

CGIHandler().run(app)

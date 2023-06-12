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

@app.route('/addproduct', methods=["GET"])
def register_product_get():
    try:
        return render_template("addproduct.html")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.

@app.route('/addproduct', methods=["POST"])
def register_product_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        sku = request.form["sku"]
        name = request.form['name']
        description = request.form["description"]
        price = request.form["price"]
        ean = request.form["ean"]
        data = (sku, name, description, price, ean)
        if name == "" or sku == "" or description == "" or price == "" or ean == "":
            return redirect("/proj.cgi/addproduct")
        query = "INSERT INTO product(sku, name, description, price, ean) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(query, data)
        return render_template("success.html", context="product")
    except Exception as e:
        return render_template("error.html", error=e, context="product") #Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/removeproduct', methods=["GET"])
def remove_product_get():
    try:
        return render_template("removeproduct.html")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.


@app.route('/removeproduct', methods=["POST"])
def remove_product_post():
    dbConn=None
    cursor=None
    cust_no = request.args.get("sku")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "DELETE FROM product WHERE sku=%s;"
        cursor.execute(query, (cust_no, ))
        return render_template("success.html", context="customer")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/registersupplier', methods=["GET"])
def register_supplier_get():
    try:
        return render_template("registersupplier.html")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.

@app.route('/registersupplier', methods=["POST"])
def register_supplier_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        tin = request.form["tin"]
        name = request.form["name"]
        address = request.form["address"]
        product = request.form["product_sku"]
        date = request.form["date"]
        data = (tin, name, address, product, date)
        if name == "" or tin == "" or address == "" or product == "" :
            return redirect("/proj.cgi/addretailer")
        query = "INSERT INTO supplier(tin, name, adress, product, date) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(query, data)
        return render_template("success.html", context="supplier")
    except Exception as e:
        return render_template("error.html", error=e, context="supplier") #Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/removesupplier', methods=['GET'])
def remove_supplier_get():
    try:
        return render_template("removesupplier.html")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.

@app.route('/removesupplier', methods=['POST'])
def remove_supplier_post():
    dbConn=None
    cursor=None
    tin = request.args.get("tin")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "DELETE FROM supplier WHERE tin=%s;"
        cursor.execute(query, (tin, ))
        return render_template("success.html", context="supplier")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/registercustomer', methods=["GET"])
def register_customer_get():
    try:
        return render_template("registercustomer.html")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.

@app.route('/registercustomer', methods=["POST"])
def register_customer_post():
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        name = request.form["name"]
        email = request.form["email"]
        address = request.form["address"]
        phone = request.form["phone"]
        data = (cust_no, name, address, email, phone)
        if name == "" or email == "" or address == "" or phone == "" :
            return redirect("/proj.cgi/registercustomer")
        query_get_cust_no = "SELECT COALESCE(MAX(value), 0)+1 FROM customer"
        cursor.execute(query_get_cust_no)
        cust_no = cursor.fetchone()
        query = "INSERT INTO customer(cust_no, name, adress, product, date) VALUES (%s, %s, %s, %s, %s)"
        cursor.execute(query, data)
        return render_template("success.html", context="customer")
    except Exception as e:
        return render_template("error.html", error=e, context="customer") #Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/removecustomer', methods=['GET'])
def remove_supplier_get():
    try:
        return render_template("removecustomer.html")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.

@app.route('/removecustomer', methods=['POST'])
def remove_supplier():
    dbConn=None
    cursor=None
    cust_no = request.args.get("cust_no")
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "DELETE FROM customer WHERE cust_no=%s;"
        cursor.execute(query, (cust_no, ))
        return render_template("success.html", context="customer")
    except Exception as e:
        return render_template("error.html", error=e) #Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

CGIHandler().run(app)
